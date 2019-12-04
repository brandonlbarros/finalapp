//
//  GroupInfoViewController.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/3/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import CodableFirebase

class GroupInfoViewController: UIViewController {

    @IBOutlet var join: UIButton!
    @IBOutlet weak var group: UILabel!
    let ref = Database.database().reference()
    var g = Group(cl: "NO CLASS", number: 1)
    var user = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        group.text = g.cl
        print(user)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                var how = 1
                if (child.key == self.user) {
                    for case let sgs as DataSnapshot in child.children {
                        var k = sgs.key
                        let check = k.removeFirst()
                        if (check == "s") {
                            how = how + 1
                        }
                    }
                }
                var number = String(how)
                number = "s" + number
                let u = self.ref.child("users/" + self.user + "/" + number)
                u.child("cl").setValue(self.g.cl)
                u.child("number").setValue(String(self.g.number))
            }
        })
        
        ref.child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {

                if (child.key == self.g.cl) {
                    for case let sgs as DataSnapshot in child.children {

                        if (sgs.key == String(self.g.number)) {

                            var memb = 1
                            for case let membs as DataSnapshot in sgs.children {

                                var d = membs.key
                                if (d.removeFirst() == "m") {
                                    memb = memb + (Int(d) ?? 0)
                                }
                            }
                            let u = self.ref.child("groups/" + child.key + "/" + String(self.g.number) + "/m" + String(memb))
                        
                            u.setValue(self.user)
                        }
                    }
                }
            }
        })
        
        
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
