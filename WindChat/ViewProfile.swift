//
//  ViewProfile.swift
//  WindChat
//
//  Created by Antoine Clop on 12/9/16.
//  Copyright © 2016 clop_a. All rights reserved.
//

import UIKit

class ViewProfile: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var birthday: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmation: UITextField!
    @IBOutlet weak var modifyAccount: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.email.delegate = self
        self.firstname.delegate = self
        self.lastname.delegate = self
        self.password.delegate = self
        self.confirmation.delegate = self
        
        userTitle.text = User.user.userName
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        
        if let checkedUrl = URL(string: User.user.pictureUrl)
        {
            profileIcon.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }
        
        email.text = User.user.email
        firstname.text = User.user.firstName
        lastname.text = User.user.lastName
        let index = User.user.birthday.index(User.user.birthday.startIndex, offsetBy: 10)
        birthday.setTitle(User.user.birthday.substring(to: index), for: UIControlState.normal)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void)
    {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL)
    {
        getDataFromUrl(url: url)
        {
            data, response, error  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async()
            {
                () -> Void in
                self.profileIcon.image = UIImage(data: data)
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func disconnect(_ sender: Any)
    {
        print("Login out of " + User.user.userName)
        datePicker.isHidden = true
        logout()
    }
    
    @IBAction func saveOrDelete(_ sender: Any)
    {
        datePicker.isHidden = true
        if modifyAccount.titleLabel?.text == "Delete account"
        {
            let alert = UIAlertController(title: "WindChat", message: "Your account will be deleted permanently!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:
            {
                action in
                print("Deleting account of " + User.user.userName)
                User.user.deleteAccount()
                self.logout()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            print("Modification of the account")
            User.user.updateAccount()
            
            modifyAccount.backgroundColor = UIColor.init(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
            modifyAccount.setTitle("Delete account", for: UIControlState.normal)
        }
    }
    
    func logout()
    {
        User.user = User()
        Wind.recipients = ""
        Wind.windList = []
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "Login")
        self.present(resultViewController, animated:true, completion:nil)
    }
    
    @IBAction func emailChanges(_ sender: Any)
    {
        if email.text!.characters.count == 0
        {
            email.text = User.user.email
            fieldError(field: email)
        }
        else
        {
            User.user.email = email.text!
            fieldValid(field: email)
        }
    }
    
    @IBAction func firstnameChanges(_ sender: Any)
    {
        if firstname.text!.characters.count == 0
        {
            firstname.text = User.user.firstName
            fieldError(field: firstname)
        }
        else
        {
            User.user.firstName = firstname.text!
            fieldValid(field: firstname)
        }
    }
    
    @IBAction func lastnameChanges(_ sender: Any)
    {
        if lastname.text!.characters.count == 0
        {
            lastname.text = User.user.lastName
            fieldError(field: lastname)
        }
        else
        {
            User.user.lastName = lastname.text!
            fieldValid(field: lastname)
        }
    }
    
    @IBAction func birthdayChanges(_ sender: Any)
    {
        datePicker.isHidden = !datePicker.isHidden
        if datePicker.isHidden
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString:String = dateFormatter.string(from: datePicker.date)
            birthday.setTitle(dateString, for: UIControlState.normal)
            User.user.birthday = dateString + "T00:00:00"
            modifyAccount.backgroundColor = UIColor(red: 105/255, green: 158/255, blue: 74/255, alpha: 1)
            modifyAccount.setTitle("Save changes", for: UIControlState.normal)
        }
    }
    
    @IBAction func passwordChanges(_ sender: Any)
    {
        if password.text!.characters.count == 0 || password.text != confirmation.text
        {
            password.text = ""
            confirmation.text = ""
            fieldError(field: password)
            fieldError(field: confirmation)
        }
        else
        {
            password.backgroundColor = UIColor(red: 105/255, green: 158/255, blue: 74/255, alpha: 1)
            password.textColor = UIColor.black
            confirmation.backgroundColor = UIColor(red: 105/255, green: 158/255, blue: 74/255, alpha: 1)
            confirmation.textColor = UIColor.black
            User.user.updatePassword(new: password.text!)
        }
    }
    
    func fieldError(field: UITextField)
    {
        field.backgroundColor = UIColor.init(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
        field.textColor = UIColor.white
    }
    
    func fieldValid(field: UITextField)
    {
        field.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        field.textColor = UIColor.black
        modifyAccount.backgroundColor = UIColor(red: 105/255, green: 158/255, blue: 74/255, alpha: 1)
        modifyAccount.setTitle("Save changes", for: UIControlState.normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ username: UITextField) -> Bool
    {
        username.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
