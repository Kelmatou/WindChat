//
//  Wind.swift
//  WindChat
//
//  Created by Antoine Clop on 12/17/16.
//  Copyright © 2016 clop-a. All rights reserved.
//

import Foundation

class Wind
{
    static var windList: [Wind] = []
    static var recipients: String = ""
    
    var duration: Int = 0
    var latitude: Int = 0
    var longitude: Int = 0
    
    //part for receiving
    var sender: User = User()
    var id: Int = 0
    var sendDate: String = ""
    var imageUrl: String = ""
    var imageUrlSmall: String = ""
    var isOpened: Bool = false
    
    //part for sending
    static var time: Int = 10
    var image64: String = ""
    
    static func updateWindList()
    {
        let request = Requester()
        let url: String = request.API_ENTRY_POINT + request.WIND_LIST
        request.GetRequest(url: url, authenticated: true, getResult:
        {
            succeed, data, response in
            if succeed
            {
                Wind.parse(data: data!)
            }
            else
            {
                print("Update wind list failed")
            }
        })
    }
    
    static func parse(data: Data?)
    {
        do
        {
            let array = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String: Any]]
            for (_, json) in (array?.enumerated())!
            {
                let id = json["id"] as! Int
                let firstname = (json["firstName"] as? String)!
                let lastname = (json["lastName"] as? String)!
                let username = (json["userName"] as? String)!
                let pictureURL = (json["pictureUrl"] as? String)!
                let pictureURLSmall = (json["pictureUrlSmall"] as? String)!
                let windsData = (json["winds"] as? [[String: Any]])!
                for (_, winds) in (windsData.enumerated())
                {
                    let newWind: Wind = Wind()
                    newWind.sender.id = id
                    newWind.sender.firstName = firstname
                    newWind.sender.lastName = lastname
                    newWind.sender.userName = username
                    newWind.sender.pictureUrl = pictureURL
                    newWind.sender.pictureUrlSmall = pictureURLSmall
                    newWind.id = winds["id"] as! Int
                    newWind.sendDate = (winds["sendDate"] as? String)!
                    newWind.latitude = winds["latitude"] as! Int
                    newWind.longitude = winds["longitude"] as! Int
                    newWind.duration = winds["duration"] as! Int
                    newWind.imageUrl = (winds["imageUrl"] as? String)!
                    newWind.imageUrlSmall = (winds["imageUrlSmall"] as? String)!
                    newWind.isOpened = winds["isOpened"] as! Bool
                    Wind.windList.append(newWind)
                }
            }
        }
        catch
        {
            print("Error while parsing JSON")
        }
    }
    
    func send()
    {
        let request = Requester()
        let urlFriendInfo = request.API_ENTRY_POINT + request.USER_INFO + "/" + Wind.recipients
        let url: String = request.API_ENTRY_POINT + request.WIND_MANAGE
        var message: String = "{\n\"duration\":"
        message += String(Wind.time)
        message += ",\n\"latitude\":"
        message += String(latitude)
        message += ",\n\"longitude\":"
        message += String(longitude)
        message += ",\n\"recipients\":[\n"
        request.GetRequest(url: urlFriendInfo, authenticated: true, getResult:
        {
            succeed, data, response in
            if succeed
            {
                let friend: User = self.parseUserList(data: data)
                message += String(friend.id)
            }
            else
            {
                print("Failed to get information from " + Wind.recipients)
                return
            }
            message += "\n],\n\"image\":\""
            message += self.image64
            message += "\"\n}"
            request.PostRequest(url: url, content: message, authenticated: true, getResult:
            {
                succeed, data, response in
                DispatchQueue.main.async
                {
                    if succeed
                    {
                        print("Successfully sent a Wind")
                    }
                    else
                    {
                        print("Failed to send Wind")
                    }
                }
            })
        })
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
}
