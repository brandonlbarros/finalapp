//
//  ClassInfoViewController.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/3/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import CodableFirebase

class ClassInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JoinGroupDelegate {
    
    func isIn(_ num: Int) {
        alreadyIn.append(num)
        groups.reloadData()
    }
    

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var prof: UILabel!
    @IBOutlet weak var descrip: UITextView!
    @IBOutlet weak var groups: UITableView!
    let ref = Database.database().reference()
    var cl = Class(name: "Class", description: nil, professor: nil)
    var sGroups = [Group]()
    var alreadyIn: [Int] = []
    var user = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descrip.isEditable = false
        name.text = cl.name.uppercased()
        
        
        ref.child("classes").observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                do {
                    let m = try FirebaseDecoder().decode(Class.self, from: child.value)
                    
                    if(m.name.uppercased() == self.name.text) {
                        self.prof.text = "Professor: " + (m.professor ?? "")
                        self.descrip.text = m.description
                    }
                } catch let error {
                    print(error)
                }
            }
        })
        
        ref.child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                var num = 0
                if(child.key == self.cl.name) {
                    for case let gr as DataSnapshot in child.children {
                        do {
                            let m = try FirebaseDecoder().decode(Group.self, from: gr.value)
                            num = m.number
                            self.sGroups.append(m)
                            self.groups.reloadData()
                            
                        } catch let error {
                            print(error)
                        }
                        for case let memb as DataSnapshot in gr.children {
                            var uIn = false
                            if let p = memb.value as? String {
                                if (p == self.user) {
                                    uIn = true
                                }
                            }
                            if (uIn) {
                                self.alreadyIn.append(num)
                                self.groups.reloadData()
                            }
                        }
                    }
                }
            }
        })

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didSelectAdd(_ sender: UIBarButtonItem) {
        // TODO: Present an alert view with a text field. When "Done" is pressed, a new NewsItem should be created and inserted at the START of your array of items, and the table view data should be reloaded
        ref.child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
            var found = false
            for case let child as DataSnapshot in snapshot.children {
                if(child.key == self.cl.name) {
                    found = true
                    var h = 1
                    for case let gr as DataSnapshot in child.children {
                        h = h + 1
                    }
                    let x = self.ref.child("groups/" + self.cl.name + "/" + String(h))
                    let new = Group(cl: self.cl.name, number: h)
                    self.sGroups.append(new)
                    x.child("cl").setValue(self.cl.name)
                    x.child("number").setValue(h)
                    x.child("m1").setValue(self.user)
                    self.alreadyIn.append(h)
                    self.groups.reloadData()
                }
            }
            if (!found) {
                let x = self.ref.child("groups/" + self.cl.name + "/" + String(1))
                let new = Group(cl: self.cl.name, number: 1)
                self.sGroups.append(new)
                x.child("cl").setValue(self.cl.name)
                x.child("number").setValue(1)
                x.child("m1").setValue(self.user)
                self.alreadyIn.append(1)
                self.groups.reloadData()
                
            }
        })
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                if(child.key == self.user) {
                    var h = 1
                    for case let gr as DataSnapshot in child.children {
                        var s = gr.key
                        if (s.removeFirst() == "s") {
                            h = h + 1
                        }
                    }
                    let x = self.ref.child("users/" + self.user + "/s" + String(h))
                    x.child("cl").setValue(self.cl.name)
                    x.child("number").setValue(String(h))
                    self.groups.reloadData()
                }
            }
        })
        let alertController = UIAlertController(title: "Let's Get Studying!", message:
            "You've Created a new group!" , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (sGroups.count == 0) {
            return 1
        }
        return sGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if (sGroups.count == 0) {
            if let t = cell?.viewWithTag(1) as? UILabel {
                t.text = "No groups! Click on the '+' to add some"
                t.font = UIFont.systemFont(ofSize: 15.0)
            }
        } else {
            if (alreadyIn.contains(sGroups[indexPath.row].number)) {
                cell?.backgroundColor = UIColor.green
                print ("HERE")
            }
            if let t = cell?.viewWithTag(1) as? UILabel {
                let a = sGroups[indexPath.row]
                let num = String(a.number)
                t.text = "Group " + num
                t.font = UIFont.systemFont(ofSize: 15.0)
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    
    // MARK: - Handle user interaction
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Deselect the cell, and toggle the "favorited" property in your model
        performSegue(withIdentifier: "toGroupInfo", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "toGroupInfo":
                if let vc = segue.destination as? GroupInfoViewController {
                    if let i = sender as? IndexPath {
                        vc.g = sGroups[i.row]
                        vc.user = self.user
                        vc.delegate = self
                    }
                    
                }

            default:
                break
            }
        }
    }


}
