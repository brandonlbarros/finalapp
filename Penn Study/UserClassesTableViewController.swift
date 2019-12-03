//
//  UserClassesTableViewController.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/2/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//

import UIKit

class UserClassesTableViewController: UITableViewController {
    

    var tabbar: UserHomeViewController? = nil
    var classes: [Class] = [Class]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tabbar = tabBarController as! UserHomeViewController
        //classes = tabbar!.person.classes
        
        
       
        
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
        }
        
        
        
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    // MARK: - Handle user interaction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Deselect the cell, and toggle the "favorited" property in your model
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "toClassList":
                if let vc = segue.destination as? ClassListTableViewController {
                    
                    vc.uClass = self.classes
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
