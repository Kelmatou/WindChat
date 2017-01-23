//
//  ScrollView.swift
//  WindChat
//
//  Created by Antoine Clop on 12/12/16.
//  Copyright © 2016 clop-a. All rights reserved.
//

import UIKit

class ScrollView: UIViewController
{
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let camera : ViewCamera = ViewCamera(nibName: "ViewCamera", bundle: nil)
        let profile : ViewProfile = ViewProfile(nibName: "ViewProfile", bundle: nil)
        let friends : ViewFriends = ViewFriends(nibName: "ViewFriends", bundle: nil)
        let functionalities : Functionalities = Functionalities(nibName: "Functionalities", bundle: nil)
        
        self.addChildViewController(camera)
        self.scrollView.addSubview(camera.view)
        camera.didMove(toParentViewController: self)
        
        self.addChildViewController(profile)
        self.scrollView.addSubview(profile.view)
        profile.didMove(toParentViewController: self)
        
        self.addChildViewController(friends)
        self.scrollView.addSubview(friends.view)
        friends.didMove(toParentViewController: self)
        
        self.addChildViewController(functionalities)
        self.scrollView.addSubview(functionalities.view)
        functionalities.didMove(toParentViewController: self)
        
        var transition1 : CGRect = profile.view.frame
        transition1.origin.x = self.view.frame.width
        profile.view.frame = transition1
        
        var transition2 : CGRect = friends.view.frame
        transition2.origin.y = self.view.frame.height
        friends.view.frame = transition2
        
        var transition3 : CGRect = functionalities.view.frame
        transition3.origin.x = self.view.frame.width
        transition3.origin.y = self.view.frame.height
        functionalities.view.frame = transition3
        
        let size = CGSize(width: self.view.frame.width * 2, height: self.view.frame.size.height * 2)
        self.scrollView.contentSize = size
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

