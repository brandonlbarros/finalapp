//
//  UserClassesTableViewController.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/2/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import CodableFirebase

class UserClassesTableViewController: UITableViewController, AddClassDelegate {
    
    

    var tabbar: UserHomeViewController? = nil
    var classes: [Class] = [Class]()
    let ref = Database.database().reference()
    var user = ""
    
    
    func didAdd(_ c: Class) {
        classes.append(c)
        self.tableView.reloadData()

        ref.child("users/" + user + "/c" + String(classes.count)).setValue(c.name)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tabbar = tabBarController as! UserHomeViewController
        //classes = tabbar!.person.classes
        user = tabbar?.user ?? "user"
        
        
        
        ref.child("users/" + user).observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                var k = child.key
                let y = k.removeFirst()
                if (Int(k) != nil && y == "c") {
                    if let s = child.value as? String {
                        self.classes.append(Class(name: s, description: nil, professor: nil))
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
       
        
    }
    
    @IBAction func didSelectAdd(_ sender: UIBarButtonItem) {
        // TODO: Present an alert view with a text field. When "Done" is pressed, a new NewsItem should be created and inserted at the START of your array of items, and the table view data should be reloaded
        
        performSegue(withIdentifier: "toClassList", sender: sender)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (classes.count > 0) {
            return classes.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Deque a cell from the table view and configure its UI. Set the label and star image by using cell.viewWithTag(..)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if (classes.count == 0) {
            if let t = cell?.viewWithTag(1) as? UILabel {
                t.text = "No classes! Click on the '+' to add some"
                t.font = UIFont.systemFont(ofSize: 15.0)
            }
        } else {
            let c = classes[indexPath.row]
            if let t = cell?.viewWithTag(1) as? UILabel {
                t.text = c.name
                t.font = UIFont.systemFont(ofSize: 25.0)
            }
        }

        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    // MARK: - Handle user interaction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Deselect the cell, and toggle the "favorited" property in your model
        
        if (classes.count == 0) {
            return
        }
        performSegue(withIdentifier: "toClassInfo", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "toClassList":
                if let vc = segue.destination as? ClassListTableViewController {
                    
                    vc.delegate = self
                    vc.uClass = self.classes
                }
                
            case "toClassInfo":
                if let vc = segue.destination as? ClassInfoViewController {
                    if let i = sender as? IndexPath {
                        vc.cl = self.classes[i.row]
                        vc.user = self.user
                    } 
                }
                
            default:
                break
            }
        }
    }
    
    
    
    // MARK: - Swipe to delete functionality
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: If the editing style is deletion, remove the newsItem from your model and then delete the rows. CAUTION: make sure you aren't calling tableView.reloadData when you update your model -- calling both tableView.deleteRows and tableView.reloadData will make the app crash.
        if (editingStyle == .delete) {
            newsItems.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }*/

}
