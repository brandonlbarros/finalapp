//
//  ClassListTableViewController.swift
//  FirebaseCore
//
//  Created by Brandon Barros on 12/3/19.
//

import UIKit
import FirebaseDatabase
import Firebase
import CodableFirebase

class ClassListTableViewController: UITableViewController {
    
    var classes = [Class]()
    var uClass = [Class]()
    let ref = Database.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = "back"
        
        
        ref.child("classes").observeSingleEvent(of: .value, with: { (snapshot) in
            for i in 1 ... snapshot.childrenCount {
                print(i)
                self.ref.child("classes/" + String(i)).observeSingleEvent(of: .value, with: { (snap) in
                    do {
                        let model = try FirebaseDecoder().decode(Class.self, from: snap.value)
                        var a = true
                        for u in self.uClass {
                            if (u.name == model.name) {
                                a = false
                            }
                        }
                        if (a) {
                            self.classes.append(model)
                        }
                        self.tableView.reloadData()
                        
                        
                    } catch let error {
                        print(error)
                    }
                })
            }
        })
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Deque a cell from the table view and configure its UI. Set the label and star image by using cell.viewWithTag(..)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if let name = cell?.viewWithTag(1) as? UILabel {
            name.text = classes[indexPath.row].name
        }
        
        if let descrip = cell?.viewWithTag(2) as? UILabel {
            descrip.text = classes[indexPath.row].description
        }
        
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    // MARK: - Handle user interaction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Deselect the cell, and toggle the "favorited" property in your model
        uClass.append(classes[indexPath.row])
        classes.remove(at: indexPath.row)
        self.tableView.reloadData()
        
        
    }
}
