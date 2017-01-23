//
//  User.swift
//  WindChat
//
//  Created by Antoine Clop on 12/10/16.
//  Copyright © 2016 clop_a. All rights reserved.
//

import Foundation

class User
{
    static var user = User()
    
    var id: Int = 0
    var token: String = ""
    var password: String = ""
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var userName: String = ""
    var birthday: String = ""
    var subscribeDay: String = ""
    var pictureUrl: String = ""
    var pictureUrlSmall: String = ""
    var friendList: [String] = []
    var pendingList: [String] = []
    
    func updateAccount()
    {
        let request = Requester()
        let url: String = request.API_ENTRY_POINT + request.USER_SETTINGS
        var message: String = "{\n\"email\":\""
        message += email
        message += "\",\n\"firstName\":\""
        message += firstName
        message += "\",\n\"lastName\":\""
        message += lastName
        message += "\",\n\"birthday\":\""
        message += birthday
        message += "\",\n\"imageStr64\":\"\"\n}"
        request.PutRequest(url: url, content: message, authenticated: true, getResult:
        {
            succeed, data, response in
            if succeed
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
                    self.id = json?["id"] as! Int
                    self.email = (json?["email"] as? String)!
                    self.firstName = (json?["firstName"] as? String)!
                    self.lastName = (json?["lastName"] as? String)!
                    self.userName = (json?["userName"] as? String)!
                    self.birthday = (json?["birthday"] as? String)!
                    self.subscribeDay = (json?["subscribeDay"] as? String)!
                    self.pictureUrl = (json?["pictureUrl"] as? String)!
                    self.pictureUrlSmall = (json?["pictureUrlSmall"] as? String)!
                    print("Account updated successfully")
                }
                catch
                {
                    print("Error while parsing JSON")
                }
            }
            else
            {
                print("Account update failed")
            }
        })
    }
    
    func updatePassword(new: String)
    {
        let request = Requester()
        let url: String = request.API_ENTRY_POINT + request.USER_PASSWORD
        var message: String = "{\n\"currentPassword\":\""
        message += self.password
        message += "\",\n\"newPassword\":\""
        message += new
        message += "\"\n}"
        request.PutRequest(url: url, content: message, authenticated: true, getResult:
            {
                succeed, data, response in
                if succeed
                {
                    self.password = new
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
                        self.id = json?["id"] as! Int
                        self.token = (json?["token"] as? String)!
                        self.email = (json?["email"] as? String)!
                        self.firstName = (json?["firstName"] as? String)!
                        self.lastName = (json?["lastName"] as? String)!
                        self.userName = (json?["userName"] as? String)!
                        self.birthday = (json?["birthday"] as? String)!
                        self.subscribeDay = (json?["subscribeDay"] as? String)!
                        self.pictureUrl = (json?["pictureUrl"] as? String)!
                        self.pictureUrlSmall = (json?["pictureUrlSmall"] as? String)!
                        print("Password updated successfully")
                    }
                    catch
                    {
                        print("Error while parsing JSON")
                    }
                }
                else
                {
                    print("Password update failed")
                }
        })
    }
    
    func deleteAccount()
    {
        let request = Requester()
        let url: String = request.API_ENTRY_POINT + request.USER_SETTINGS
        request.DeleteRequest(url: url, authenticated: true, getResult:
        {
            succeed, data, response in
            if succeed
            {
                print("Account deleted successfully")
            }
            else
            {
                print("Account deletion failed")
            }
        })
    }
}
