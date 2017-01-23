//
//  Requester.swift
//  WindChat
//
//  Created by Antoine Clop on 12/10/16.
//  Copyright © 2016 clop_a. All rights reserved.
//

import Foundation

class Requester
{
    let API_ENTRY_POINT = "http://windchatapi.3ie.fr/api"
    let API_KEY = "{C@@Q=PA9XH-G1PFNRY\\ZT-FR2VD;Z79K}"
    
    let USER_REGISTER = "/user/register"       //used to register a new user
    let USER_LOGIN = "/user/login"             //used to log in a known user
    let USER_INFO = "/user/search"             //used to get information about a user [AUTHENTICATED]
    let USER_SETTINGS = "/user/profile"        //used to delete an account [AUTHENTICATED]
    let USER_PASSWORD = "/user/password"        //used to change password [AUTHENTICATED]
    let FRIEND_MANAGE = "/friend"              //used to add a new friend [AUTHENTICATED]
    let FRIEND_LIST = "/friend/list"           //used to recover the user's friend list [AUTHENTICATED]
    let FRIEND_PENDING = "/friend/pendingList" //used to recover the user's friend list [AUTHENTICATED]
    let WIND_MANAGE = "/wind"                  //used to send or open winds [AUTHENTICATED]
    let WIND_LIST = "/wind/list"               //used to get list of winds [AUTHENTICATED]

    /*
     * @brief   sends a POST request to the API
     * @param   url : the API target
     * @param   content : the content to POST on the server
     */
    func PostRequest(url: String, content: String, authenticated: Bool,
                     getResult: @escaping (Bool, Data?, NSString?) -> Void)
    {
        var uri: NSURL
        if url[url.index(before: url.endIndex)] == " "
        {
            uri = NSURL(string: url.substring(to: url.index(before: url.endIndex)))!
        }
        else
        {
            uri = NSURL(string: url)!

        }
        let request = NSMutableURLRequest(url: uri as URL)
        request.httpMethod = "POST"
        request.httpBody = content.data(using: String.Encoding.utf8)
        request.addValue(self.API_KEY, forHTTPHeaderField: "X-Api-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if authenticated
        {
            request.addValue("Bearer " + User.user.token, forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            if error != nil
            {
                print("connection error")
                getResult(false, nil, nil)
                return
            }
            let responseDecoded = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let responseCode = response as! HTTPURLResponse
            print("API response code: \(responseCode.statusCode)")
            print("API response:")
            print(responseDecoded!)
            
            if responseCode.statusCode == 200
            {
                getResult(true, data, responseDecoded!)
            }
            else
            {
                getResult(false, data, responseDecoded!)
            }
        }
        task.resume()
    }
    
    /*
     * @brief   sends a GET request to the API
     * @param   url : the API target
     */
    func GetRequest(url: String, authenticated: Bool,
                    getResult: @escaping (Bool, Data?, NSString?) -> Void)
    {
        var uri: NSURL
        if url[url.index(before: url.endIndex)] == " "
        {
            uri = NSURL(string: url.substring(to: url.index(before: url.endIndex)))!
        }
        else
        {
            uri = NSURL(string: url)!
            
        }
        let request = NSMutableURLRequest(url: uri as URL)
        request.httpMethod = "GET"
        request.addValue(self.API_KEY, forHTTPHeaderField: "X-Api-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if authenticated
        {
            request.addValue("Bearer " + User.user.token, forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            if error != nil
            {
                print("connection error")
                getResult(false, nil, nil)
                return
            }
            let responseDecoded = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let responseCode = response as! HTTPURLResponse
            print("API response code: \(responseCode.statusCode)")
            print("API response:")
            print(responseDecoded!)
            
            if responseCode.statusCode == 200
            {
                getResult(true, data, responseDecoded!)
            }
            else
            {
                getResult(false, data, responseDecoded!)
            }
        }
        task.resume()
    }
    
    /*
     * @brief   sends a PUT request to the API
     * @param   url : the API target
     * @param   content : the content to PUT on the server
     */
    func PutRequest(url: String, content: String, authenticated: Bool,
                    getResult: @escaping (Bool, Data?, NSString?) -> Void)
    {
        var uri: NSURL
        if url[url.index(before: url.endIndex)] == " "
        {
            uri = NSURL(string: url.substring(to: url.index(before: url.endIndex)))!
        }
        else
        {
            uri = NSURL(string: url)!
            
        }
        let request = NSMutableURLRequest(url: uri as URL)
        request.httpMethod = "PUT"
        request.httpBody = content.data(using: String.Encoding.utf8)
        request.addValue(self.API_KEY, forHTTPHeaderField: "X-Api-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if authenticated
        {
            request.addValue("Bearer " + User.user.token, forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            if error != nil
            {
                print("connection error")
                getResult(false, nil, nil)
                return
            }
            let responseDecoded = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let responseCode = response as! HTTPURLResponse
            print("API response code: \(responseCode.statusCode)")
            print("API response:")
            print(responseDecoded!)
            
            if responseCode.statusCode == 200
            {
                getResult(true, data, responseDecoded!)
            }
            else
            {
                getResult(false, data, responseDecoded!)
            }
        }
        task.resume()
    }
    
    /*
     * @brief   sends a DETELE request to the API
     * @param   url : the API target
     */
    func DeleteRequest(url: String, authenticated: Bool,
                       getResult: @escaping (Bool, Data?, NSString?) -> Void)
    {
        var uri: NSURL
        if url[url.index(before: url.endIndex)] == " "
        {
            uri = NSURL(string: url.substring(to: url.index(before: url.endIndex)))!
        }
        else
        {
            uri = NSURL(string: url)!
            
        }
        let request = NSMutableURLRequest(url: uri as URL)
        request.httpMethod = "DELETE"
        request.addValue(self.API_KEY, forHTTPHeaderField: "X-Api-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if authenticated
        {
            request.addValue("Bearer " + User.user.token, forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            if error != nil
            {
                print("connection error")
                getResult(false, nil, nil)
                return
            }
            let responseDecoded = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let responseCode = response as! HTTPURLResponse
            print("API response code: \(responseCode.statusCode)")
            print("API response:")
            print(responseDecoded!)
            
            if responseCode.statusCode == 200
            {
                getResult(true, data, responseDecoded!)
            }
            else
            {
                getResult(false, data, responseDecoded!)
            }
        }
        task.resume()
    }
    
    
}
