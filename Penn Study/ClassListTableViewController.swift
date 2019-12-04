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

protocol AddClassDelegate: class {
    func didAdd(_ c: Class)
}

class ClassListTableViewController: UITableViewController {
    
    var classes = [Class]()
    var uClass = [Class]()
    let ref = Database.database().reference()
    weak var delegate: AddClassDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationBar.backBarButtonItem?.title = "back"
        self.navigationController?.navigationBar.backItem?.title = "back"
        
        ref.child("classes").observeSingleEvent(of: .value, with: { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                
                do {
                    let m = try FirebaseDecoder().decode(Class.self, from: child.value)
                    var a = true
                    for u in self.uClass {
                        if (m.name == u.name) {
                            a = false
                        }
                    }
                    if(a) {
                        self.classes.append(m)
                        self.tableView.reloadData()
                    }
                    
                    
                } catch let error {
                    print(error)
                }
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
            descrip.text = classes[indexPath.row].professor
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
        self.delegate?.didAdd(classes[indexPath.row])
        classes.remove(at: indexPath.row)
        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
}
