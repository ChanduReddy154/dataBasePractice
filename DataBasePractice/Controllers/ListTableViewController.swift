//
//  ListTableViewController.swift
//  DataBasePractice
//
//  Created by Chandu Reddy on 15/07/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   var itemArray = [Items]()
    
    var selectedCategory: Categories? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search Something"
           
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            
//        if let items = defaults.array(forKey: "DataUsers") as? [String] {
//            itemArray = items
//        }
        }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = item.title
        
        // Using terinary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
}
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add Items", message: "Your Items", preferredStyle: .alert)
//        let label = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height:18))
//        label.textAlignment = .center
//        label.textColor = .red
//        label.font = label.font.withSize(12)
//        alert.view.addSubview(label)
//        label.isHidden = true
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Items(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            newItem.parentCell = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write Something"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        do{
            try context.save()
            }catch {
            print("error in context")
    }
            self.tableView.reloadData()
                   
    }
    func loadItems(with request : NSFetchRequest<Items> = Items.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCell.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate =  NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        do {
            itemArray = try context.fetch(request)
            }catch {
                print("error in fetching")
            }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let request: NSFetchRequest<Items> = Items.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //let request: NSFetchRequest<Items> = Items.fetchRequest()
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



