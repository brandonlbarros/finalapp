//
//  LogInViewController.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/1/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LogInViewController: UIViewController {

    
    @IBOutlet var log: UIButton!
    @IBOutlet weak var pennKey: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var error: UILabel!
    
        let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        error.text = ""
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        if (pennKey.text == "" || password.text == "") {
            
            
            error.text = "Please Enter Information"
        } else {
            let user = pennKey.text
            let pw = password.text
            
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if !snapshot.hasChild(user!){
                    
                    self.error.text = "User Doesn't Exist"
                    
                } else {
                    
                    self.ref.child("users/" + user! + "/password").observeSingleEvent(of: .value, with: { (snap) in
                        
                        
                        if let passwordReal = snap.value as? String {
                            if (passwordReal == pw) {
                                self.performSegue(withIdentifier: "toUserHomeFromLogIn", sender: sender)
                            } else {
                                self.error.text = "Incorrect Password"
                            }
                        }
                        
                    })
                }
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "toUserHomeFromLogIn":
                if let vc = segue.destination as? UserHomeViewController {
                    
                    vc.user = pennKey.text ?? "None"
                }
            default:
                break
            }
        }
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
