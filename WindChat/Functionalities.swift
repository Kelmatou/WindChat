//
//  Functionalities.swift
//  WindChat
//
//  Created by Antoine Clop on 12/12/16.
//  Copyright © 2016 clop-a. All rights reserved.
//

import UIKit

class Functionalities: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userNotFound: UIButton!
    @IBOutlet weak var grayIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var remove: UIButton!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var viewWind: UIButton!

    @IBOutlet weak var windDisplay: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.username.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func openWinds(_ sender: Any)
    {
        if Wind.recipients != ""
        {
            startRequest()
            openWindsFrom(username: Wind.recipients)
            endRequest()
        }
        else
        {
            userNotFound.setTitle("No friend specified", for: UIControlState.normal)
            userNotFound.backgroundColor = UIColor(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
            self.userNotFound.isHidden = false
        }
    }
    
    @IBAction func addFriend(_ sender: Any)
    {
        startRequest()
        if username.text != ""
        {
            fieldValid(field: username)
            let request = Requester()
            let url: String = request.API_ENTRY_POINT + request.FRIEND_MANAGE
            var message: String = "{\n\"userName\":\""
            message += username.text!
            message += "\"\n}"
            request.PostRequest(url: url, content: message, authenticated: true, getResult:
            {
                succeed, data, response in
                DispatchQueue.main.async
                {
                    if succeed
                    {
                        self.userNotFound.setTitle(self.username.text! + " added", for: UIControlState.normal)
                        self.userNotFound.backgroundColor = UIColor(red: 105/255, green: 158/255, blue: 74/255, alpha: 1)
                        print(self.username.text! + " added")
                        self.username.text = ""
                    }
                    else
                    {
                        if User.user.friendList.contains(self.username.text!)
                        {
                            self.userNotFound.setTitle(self.username.text! + " is already your friend", for: UIControlState.normal)
                        }
                        else
                        {
                            if User.user.pendingList.contains(self.username.text!)
                            {
                                self.userNotFound.setTitle(self.username.text! + " needs to be accepted", for: UIControlState.normal)
                            }
                            else
                            {
                                self.userNotFound.setTitle("User not found", for: UIControlState.normal)
                            }
                        }
                        self.userNotFound.backgroundColor = UIColor(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
                    }
                    self.userNotFound.isHidden = false
                }
            })
        }
        else
        {
            fieldError(field: username)
        }
        endRequest()
    }
    
    @IBAction func removeFriend(_ sender: Any)
    {
        startRequest()
        if username.text != ""
        {
            fieldValid(field: username)
            let request = Requester()
            
            let urlFriendInfo = request.API_ENTRY_POINT + request.USER_INFO + "/" + username.text!
            request.GetRequest(url: urlFriendInfo, authenticated: true, getResult:
                {
                    succeed, data, response in
                    if succeed
                    {
                        let friend: User = self.parseUserList(data: data)
                        let urlDelete: String = request.API_ENTRY_POINT + request.FRIEND_MANAGE + "/" + String(friend.id)
                        request.DeleteRequest(url: urlDelete, authenticated: true, getResult:
                            {
                                succeed, data, response in
                                DispatchQueue.main.async
                                {
                                    if succeed
                                    {
                                        self.userNotFound.setTitle(self.username.text! + " removed", for: UIControlState.normal)
                                        self.userNotFound.backgroundColor = UIColor(red: 105/255, green: 158/255, blue: 74/255, alpha: 1)
                                        print(self.username.text! + " removed")
                                        self.removeFriendFromList(key: self.username.text!)
                                        self.username.text = ""
                                    }
                                    else
                                    {
                                        self.userNotFound.setTitle(self.username.text! + " is not your friend",
                                                                   for: UIControlState.normal)
                                        self.userNotFound.backgroundColor = UIColor(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
                                    }
                                    self.userNotFound.isHidden = false
                                }
                        })
                    }
                    else
                    {
                        self.userNotFound.setTitle("User not found", for: UIControlState.normal)
                        self.userNotFound.backgroundColor = UIColor(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
                    }
                    self.userNotFound.isHidden = false
            })
        }
        else
        {
            fieldError(field: username)
        }
        endRequest()
    }
    
    @IBAction func acceptFriend(_ sender: Any)
    {
        startRequest()
        if username.text != ""
        {
            fieldValid(field: username)
            let request = Requester()
            
            let urlFriendInfo = request.API_ENTRY_POINT + request.USER_INFO + "/" + username.text!
            request.GetRequest(url: urlFriendInfo, authenticated: true, getResult:
                {
                    succeed, data, response in
                    if succeed
                    {
                        let friend: User = self.parseUserList(data: data)
                        let urlDelete: String = request.API_ENTRY_POINT + request.FRIEND_MANAGE + "/" + String(friend.id) + "/accept"
                        let message: String = "{\n\"isAccepted\":true\n}"
                        request.PutRequest(url: urlDelete, content: message, authenticated: true, getResult:
                            {
                                succeed, data, response in
                                DispatchQueue.main.async
                                    {
                                        if succeed
                                        {
                                            self.userNotFound.setTitle(self.username.text! + " accepted", for: UIControlState.normal)
                                            self.userNotFound.backgroundColor = UIColor(red: 105/255, green: 158/255, blue: 74/255, alpha: 1)
                                            print(self.username.text! + " accepted")
                                            User.user.friendList.append(self.username.text!)
                                            self.removePendingFromList(key: self.username.text!)
                                            self.username.text = ""
                                        }
                                        else
                                        {
                                            if User.user.pendingList.contains(self.username.text!)
                                            {
                                                self.userNotFound.setTitle("An error occured :(", for: UIControlState.normal)
                                            }
                                            else
                                            {
                                                self.userNotFound.setTitle(self.username.text! + " never asked to be friend", for: UIControlState.normal)
                                            }
                                            self.userNotFound.backgroundColor = UIColor(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
                                        }
                                        self.userNotFound.isHidden = false
                                }
                        })
                    }
                    else
                    {
                        self.userNotFound.setTitle("User not found", for: UIControlState.normal)
                        self.userNotFound.backgroundColor = UIColor(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
                    }
                    self.userNotFound.isHidden = false
            })
        }
        else
        {
            fieldError(field: username)
        }
        endRequest()
    }
    
    func parseUserList(data: Data?) -> User
    {
        let newUser = User()
        do
        {
            let array = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String: Any]]
            for (_, json) in (array?.enumerated())!
            {
                newUser.id = json["id"] as! Int
                newUser.email = (json["email"] as? String)!
                newUser.firstName = (json["firstName"] as? String)!
                newUser.lastName = (json["lastName"] as? String)!
                newUser.userName = (json["userName"] as? String)!
                newUser.birthday = (json["birthday"] as? String)!
                newUser.subscribeDay = (json["subscribeDay"] as? String)!
                newUser.pictureUrl = (json["pictureUrl"] as? String)!
                newUser.pictureUrlSmall = (json["pictureUrlSmall"] as? String)!
            }
        }
        catch
        {
            print("Error while parsing JSON")
        }
        return newUser
    }
    
    func removeFriendFromList(key: String)
    {
        if User.user.friendList.contains(key)
        {
            if let index = User.user.friendList.index(of: key)
            {
                User.user.friendList.remove(at: index)
                return
            }
        }
    }
    
    func removePendingFromList(key: String)
    {
        if User.user.pendingList.contains(key)
        {
            if let index = User.user.pendingList.index(of: key)
            {
                User.user.pendingList.remove(at: index)
                return
            }
        }
    }
    
    func openWindsFrom(username: String)
    {
        print("Opening Winds from " + username)
        var windOpenned: Int = 0
        for (_, wind) in Wind.windList.enumerated()
        {
            if wind.sender.userName == username && !wind.isOpened
            {
                windOpenned += 1
                let request = Requester()
                let url = request.API_ENTRY_POINT + request.WIND_MANAGE + "/" + String(wind.id) + "/open"
                let message: String = ""
                request.PutRequest(url: url, content: message, authenticated: true, getResult:
                {
                    succeed, data, response in
                    DispatchQueue.main.async
                    {
                        if succeed
                        {
                            wind.isOpened = true
                            self.windDisplay.isHidden = false
                            let pictureUrl = URL(string: wind.imageUrl)
                            self.windDisplay.contentMode = .scaleAspectFit
                            self.downloadImage(url: pictureUrl!)
                            _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(wind.duration), repeats: false)
                            {
                                timer in
                                self.windDisplay.isHidden = true
                            }
                        }
                        else
                        {
                            print("Couldn't open wind ID=" + String(wind.id) + " from " + wind.sender.userName)
                        }
                    }
                })
            }
        }
        if (windOpenned == 0)
        {
            userNotFound.setTitle("No wind received from " + Wind.recipients, for: UIControlState.normal)
            userNotFound.backgroundColor = UIColor.init(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
            userNotFound.isHidden = false
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
    
    func startRequest()
    {
        grayIndicator.isHidden = false
        add.isEnabled = false
        accept.isEnabled = false
        remove.isEnabled = false
        viewWind.isEnabled = false
    }
    
    func endRequest()
    {
        grayIndicator.isHidden = true
        add.isEnabled = true
        accept.isEnabled = true
        remove.isEnabled = true
        viewWind.isEnabled = true
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
                self.windDisplay.image = UIImage(data: data)
            }
        }
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
