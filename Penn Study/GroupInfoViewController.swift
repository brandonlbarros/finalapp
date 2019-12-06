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

protocol JoinGroupDelegate: class {
    func isIn(_ num: Int)
}

class GroupInfoViewController: UIViewController {

    @IBOutlet var join: UIButton!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var list: UITextView!
    let ref = Database.database().reference()
    var g = Group(cl: "NO CLASS", number: 1)
    var user = ""
    var members = [String]()
    var canJoin = true
    weak var delegate: JoinGroupDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        group.text = g.cl.uppercased()
        status.text = ""
        list.text = ""
        if (!canJoin) {
            join.isHidden = true
        }
        
        
        ref.child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                
                if (child.key == self.g.cl) {
                    for case let sgs as DataSnapshot in child.children {
                        
                        if (sgs.key == String(self.g.number)) {
                            
                            for case let membs as DataSnapshot in sgs.children {
                                
                                var d = membs.key
                                if (d.removeFirst() == "m") {
                                    if let s = membs.value as? String {
                                        self.members.append(s)
                                        if (s == self.user) {
                                            self.join.isHidden = true
                                            if (self.canJoin) {
                                                self.status.text = "You're already a member of this group"
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            if (self.members.isEmpty) {
                                self.list.text = "No members yet. Be the first"
                            } else {
                                for m in self.members {
                                    self.list.text = self.list.text + m + "\n"
                                }
                            }
                        }
                    }
                }
            }
        })
        
        

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func joinGroup(_ sender: UIButton) {
        join.isHidden = true
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            var how = 1
            for case let child as DataSnapshot in snapshot.children {
                if (child.key == self.user) {
                    for case let sgs as DataSnapshot in child.children {
                        var k = sgs.key
                        let check = k.removeFirst()
                        if (check == "s") {
                            how = how + 1
                        }
                    }
                }
            }
            var number = String(how)
            number = "s" + number
            print (number)
            let u = self.ref.child("users/" + self.user + "/" + number)
            u.child("cl").setValue(self.g.cl)
            u.child("number").setValue(String(self.g.number))
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
                                    memb = memb + 1
                                }
                            }
                            let u = self.ref.child("groups/" + child.key + "/" + String(self.g.number) + "/m" + String(memb))
                        
                            u.setValue(self.user)
                        }
                    }
                }
            }
        })
        
        delegate?.isIn(g.number)
        status.text = "Congrats! You have joined this group"
        list.text = ""
        members.append(user)
        for m in members {
            list.text = list.text + m + "\n"
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
