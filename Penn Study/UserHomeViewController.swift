//
//  UserHomeViewController.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/1/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//

import UIKit

class UserHomeViewController: UIViewController {

    
    
    var user = "user"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true;
        
        self.navigationItem.title = user;

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
