//
//  UserHomeViewController.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/1/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//

import UIKit


class UserHomeViewController: UITabBarController {

    
    
    var user = "user"
   // var person = User(name: "As", classes: [String]())
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.title = "Welcome to Penn Study, " + user + "!"

        self.tabBar.items?[0].title = "My Profile"
        
        self.tabBar.items?[1].title = "My Courses"
        
        self.tabBar.items?[2].title = "My Study Groups"
        
        
        //person = User(name: "ASA", classes: [String]())
    
        
    }
    
    
    
    

}
