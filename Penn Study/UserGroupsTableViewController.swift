//
//  UserGroupsTableViewController.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/3/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import CodableFirebase

class UserGroupsTableViewController: UITableViewController {

    
    var tabbar: UserHomeViewController? = nil
    var groups: [Group] = [Group]()
    let ref = Database.database().reference()
    var user = ""
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        
        tabbar = tabBarController as! UserHomeViewController
        //classes = tabbar!.person.classes
        user = tabbar?.user ?? "user"
        
        
        
        ref.child("users/" + user).observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                var k = child.key
                let y = k.removeFirst()
                if (Int(k) != nil && y == "s") {
                    var c = ""
                    var num = 0
                    for case let g as DataSnapshot in child.children {
                        if (g.key == "cl") {
                            c = g.value as? String ?? ""
                        }
                        if (g.key == "number") {
                            num = Int(g.value as? String ?? "") ?? 0
                        }
                    }
                    self.groups.append(Group(cl: c, number: num))
                    self.tableView.reloadData()
                    
                    
                }
            }
        })
        
        
        
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (groups.count > 0) {
            return groups.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if (groups.count == 0) {
            if let t = cell?.viewWithTag(1) as? UILabel {
                t.text = "No groups! Go to your classes to add some"
                t.font = UIFont.systemFont(ofSize: 18.0)
            }
        } else {
            if let t = cell?.viewWithTag(1) as? UILabel {
                let a = groups[indexPath.row]
                var s = String(a.number)
                t.text = a.cl + " Group " + s
                t.font = UIFont.systemFont(ofSize: 30.0)
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
