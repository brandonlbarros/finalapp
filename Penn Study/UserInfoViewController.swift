//
//  UserInfoViewController.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/3/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var pk: UILabel!
    @IBOutlet weak var intro: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tabbar = tabBarController as! UserHomeViewController
        pk.text = "PennKey: " + tabbar.user
        intro.isEditable = false
        intro.text = "Welcome to PennStudy! The best way to help you find people in your classes to help with studying, homework, or anything else! To start, go to the \"My Courses\" tab and add any classes you're in. From there, you can look at your classes by clicking on them, where you'll get a short description as well as a list of the current study groups. Then, you can select any of these groups to join. These will show up in you \"My Study Groups\" tab. Have fun!"
        
        
        
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
