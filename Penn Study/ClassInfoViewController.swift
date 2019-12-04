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

class ClassInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var prof: UILabel!
    @IBOutlet weak var descrip: UITextView!
    @IBOutlet weak var groups: UITableView!
    let ref = Database.database().reference()
    var cl = Class(name: "Class", description: nil, professor: nil)
    var sGroups = [Group]()
    var user = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descrip.isEditable = false
        name.text = cl.name
        
        
        ref.child("classes").observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                do {
                    let m = try FirebaseDecoder().decode(Class.self, from: child.value)
                    
                    if(m.name == self.name.text) {
                        self.prof.text = m.professor
                        self.descrip.text = m.description
                    }
                } catch let error {
                    print(error)
                }
            }
        })
        
        ref.child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                if(child.key == self.cl.name) {
                    for case let gr as DataSnapshot in child.children {
                        do {
                            let m = try FirebaseDecoder().decode(Group.self, from: gr.value)
                        
                            self.sGroups.append(m)
                            self.groups.reloadData()
                    
                        } catch let error {
                            print(error)
                        }
                    }
                }
            }
        })

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if (sGroups.count == 0) {
            if let t = cell?.viewWithTag(1) as? UILabel {
                t.text = "No groups! Click on the '+' to add some"
                t.font = UIFont.systemFont(ofSize: 15.0)
            }
        } else {
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
                    }
                    
                }

                
            default:
                break
            }
        }
    }


}
