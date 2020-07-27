//
//  CategoryTableViewController.swift
//  DataBasePractice
//
//  Created by Chandu Reddy on 24/07/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categoryArray = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RootCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(categoryArray[indexPath.row])
//        categoryArray.remove(at: indexPath.row)
//        saveItems()
        performSegue(withIdentifier: "CellIdentifier", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ListTableViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray[indexpath.row]
        }
    }
    
    
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Categorys", message: "Categorys", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Categories(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveItems()
        }
        
       alert.addTextField { (textFld) in
            textFld.placeholder = "Add Categories"
            textField = textFld
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
    
    func reloadData() {
        let request : NSFetchRequest<Categories> = Categories.fetchRequest()
        do {
                categoryArray = try context.fetch(request)
            }catch {
                print("error in fetching")
            }
    }
    
}
