//
//  CreateAccountViewController.swift
//  
//
//  Created by Brandon Barros on 11/26/19.
//

import UIKit
import FirebaseDatabase

class CreateAccountViewController: UIViewController {

    
    @IBOutlet var create: UIButton!
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
            
            
            error.text = "Please enter information"
        } else {
            let user = pennKey.text
            let pw = password.text
            
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(user!){
                    
                    self.error.text = "User already exists"
                    
                }else{
                    
                    let u = self.ref.child("users")
                    u.child(user! + "/password").setValue(pw)
                    self.performSegue(withIdentifier: "toUserHomeFromCreate", sender: sender)

                }
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "toUserHomeFromCreate":
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
