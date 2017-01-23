//
//  Register.swift
//  WindChat
//
//  Created by Antoine Clop on 12/12/16.
//  Copyright © 2016 clop-a. All rights reserved.
//

import UIKit

class Register: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmation: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var birthday: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var grayIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUp: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.username.delegate = self
        self.password.delegate = self
        self.confirmation.delegate = self
        self.email.delegate = self
        self.firstname.delegate = self
        self.lastname.delegate = self
        
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editDate(_ sender: Any)
    {
        datePicker.isHidden = !datePicker.isHidden
        if datePicker.isHidden
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString:String = dateFormatter.string(from: datePicker.date)
            birthday.setTitle(dateString, for: UIControlState.normal)
        }
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
    
    @IBAction func signUp(_ sender: Any)
    {
        grayIndicator.isHidden = false
        signUp.isEnabled = false
        datePicker.isHidden = true
        if username.text != ""
        {
            fieldValid(field: username)
            if password.text != ""
            {
                fieldValid(field: password)
                if confirmation.text == password.text
                {
                    fieldValid(field: confirmation)
                    if email.text != ""
                    {
                        fieldValid(field: email)
                        if firstname.text != ""
                        {
                            fieldValid(field: firstname)
                            if lastname.text != ""
                            {
                                fieldValid(field: lastname)
                                if birthday.titleLabel?.text != "Birthday"
                                {
                                    birthday.backgroundColor = UIColor.white
                                    let requester = Requester()
                                    let urlRegister : String = requester.API_ENTRY_POINT + requester.USER_REGISTER
                                    var registerJson : String = "{\n\"password\":\""
                                    registerJson += password.text!
                                    registerJson += "\",\n\"userName\":\""
                                    registerJson += username.text!
                                    registerJson += "\",\n\"email\":\""
                                    registerJson += email.text!
                                    registerJson += "\",\n\"firstName\":\""
                                    registerJson += firstname.text!
                                    registerJson += "\",\n\"lastName\":\""
                                    registerJson += lastname.text!
                                    registerJson += "\",\n\"birthday\":\""
                                    registerJson += (birthday.titleLabel?.text!)!
                                    registerJson += "T00:00:00\",\n\"imageStr64\":\"\"\n}"
                                    User.user.password = password.text!
                                    requester.PostRequest(url: urlRegister, content: registerJson,
                                                          authenticated: false, getResult:
                                        {succeed, data, response in
                                            DispatchQueue.main.async
                                                {
                                                    if succeed
                                                    {
                                                        self.parseRegister(data: data)
                                                        self.recoverFriendList()
                                                        self.recoverPendingList()
                                                        
                                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ScrollView")
                                                        self.present(resultViewController, animated:true, completion:nil)
                                                    }
                                                    else
                                                    {
                                                        self.fieldError(field: self.username)
                                                        self.fieldError(field: self.email)
                                                    }
                                            }
                                    })
                                }
                                else
                                {
                                    birthday.backgroundColor = UIColor.init(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
                                }
                            }
                            else
                            {
                                fieldError(field: lastname)
                            }
                        }
                        else
                        {
                            fieldError(field: firstname)
                        }
                    }
                    else
                    {
                        fieldError(field: email)
                    }
                }
                else
                {
                    fieldError(field: confirmation)
                }
            }
            else
            {
                fieldError(field: password)
            }
        }
        else
        {
            fieldError(field: username)
        }
        signUp.isEnabled = true
        grayIndicator.isHidden = true
    }
    
    func parseRegister(data: Data?)
    {
        do
        {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
            User.user.id = json?["id"] as! Int
            User.user.token = (json?["token"] as? String)!
            User.user.email = (json?["email"] as? String)!
            User.user.firstName = (json?["firstName"] as? String)!
            User.user.lastName = (json?["lastName"] as? String)!
            User.user.userName = (json?["userName"] as? String)!
            User.user.birthday = (json?["birthday"] as? String)!
            User.user.subscribeDay = (json?["subscribeDay"] as? String)!
            User.user.pictureUrl = (json?["pictureUrl"] as? String)!
            User.user.pictureUrlSmall = (json?["pictureUrlSmall"] as? String)!
        }
        catch
        {
            print("Error while parsing JSON")
        }
    }
    
    func fieldError(field: UITextField)
    {
        field.text = ""
        field.backgroundColor = UIColor.init(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
        field.textColor = UIColor.white
    }
    
    func fieldValid(field: UITextField)
    {
        field.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        field.textColor = UIColor.black
    }
    
    func recoverFriendList()
    {
        let request = Requester()
        let url: String = request.API_ENTRY_POINT + request.FRIEND_LIST
        request.GetRequest(url: url, authenticated: true, getResult:
            {
                succeed, data, reponse in
                DispatchQueue.main.async
                    {
                        if succeed
                        {
                            self.parseFriendList(data: data)
                        }
                        else
                        {
                            print("No friends :(")
                        }
                }
        })
    }
    
    func recoverPendingList()
    {
        let request = Requester()
        let url: String = request.API_ENTRY_POINT + request.FRIEND_PENDING
        request.GetRequest(url: url, authenticated: true, getResult:
            {
                succeed, data, reponse in
                DispatchQueue.main.async
                    {
                        if succeed
                        {
                            self.parsePendingList(data: data)
                        }
                        else
                        {
                            print("No friends :(")
                        }
                }
        })
    }
    
    func parseFriendList(data: Data?)
    {
        do
        {
            let array = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String: Any]]
            for (_, json) in (array?.enumerated())!
            {
                User.user.friendList.append((json["userName"] as? String)!)
            }
        }
        catch
        {
            print("Error while parsing JSON")
        }
    }
    
    func parsePendingList(data: Data?)
    {
        do
        {
            let array = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String: Any]]
            for (_, json) in (array?.enumerated())!
            {
                User.user.pendingList.append((json["userName"] as? String)!)
            }
        }
        catch
        {
            print("Error while parsing JSON")
        }
    }
}
