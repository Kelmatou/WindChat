//
//  ViewFriends.swift
//  WindChat
//
//  Created by Antoine Clop on 12/10/16.
//  Copyright © 2016 clop_a. All rights reserved.
//

import UIKit

class ViewFriends: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var friendList: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.friendList.delegate = self
        self.friendList.dataSource = self
        self.friendList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateFriends(_ sender: Any)
    {
        print("Updating friends")
        friendList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = tableView.indexPathForSelectedRow
        let cell: UITableViewCell = tableView.cellForRow(at: index!)!
        Wind.recipients = (cell.textLabel?.text!)!
        print("New friend selected: " + Wind.recipients)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return User.user.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = self.friendList.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = User.user.friendList[indexPath.row]
        return cell
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
