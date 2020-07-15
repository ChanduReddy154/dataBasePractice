//
//  ListTableViewController.swift
//  DataBasePractice
//
//  Created by Chandu Reddy on 15/07/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
   var itemArray = ["fuck", "you", "bitch"]
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "DataUsers") as? [String] {
            itemArray = items
        }
        }
        
        
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        tableView.deselectRow(at: indexPath, animated: true)
}
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add Items", message: "yoo bitch", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.itemArray.append(textfield.text!)
            self.defaults.set(self.itemArray, forKey: "DataUsers")
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write Something"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
