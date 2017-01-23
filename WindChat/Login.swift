//
//  ViewController.swift
//  WindChat
//
//  Created by Antoine Clop on 12/8/16.
//  Copyright © 2016 clop_a. All rights reserved.
//

import UIKit

class Login: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var GrayIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signIn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.username.delegate = self
        self.password.delegate = self
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
    
    @IBOutlet weak var badCredentialButton: UIButton!
    @IBAction func checkCredentials(_ sender: Any)
    {
        GrayIndicator.isHidden = false
        badCredentialButton.isHidden = true
        signIn.isEnabled = false
        let requester = Requester()
        let url: String = requester.API_ENTRY_POINT + requester.USER_LOGIN
        var credentials: String = "{\n\"email\":\""
        credentials += username.text!
        credentials += "\",\n\"password\":\""
        credentials += password.text!
        credentials += "\"\n}"
        User.user.password = password.text!
        requester.PostRequest(url: url, content: credentials, authenticated: false, getResult:
        {
            succeed, data, response in
            DispatchQueue.main.async
            {
                if succeed
                {
                    self.parseLogin(data: data)
                    self.recoverFriendList()
                    self.recoverPendingList()
                    Wind.updateWindList()
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ScrollView")
                    self.present(resultViewController, animated:true, completion:nil)
                }
                else
                {
                    self.badCredentialButton.isHidden = false
                }
            }
        })
        signIn.isEnabled = true
        GrayIndicator.isHidden = true
    }
    
    func parseLogin(data: Data?)
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
                            print("No pending :(")
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

