//
//  CategoryViewController.swift
//  ToDo
//
//  Created by ChanKenneth King Yan on 2018/8/31.
//  Copyright © 2018年 CQLOGIC. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
     //MARK - data source
    
    var categories : Results<Category>?
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //loadCategory()
    }
    
    //MARK - data manipulation
    func loadCategory() {

        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error core data save: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK - add new category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newCategoryText = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once user clicks the Add Item button on our UIAlert
            
            let todoCategory = Category()
            
            todoCategory.name = newCategoryText.text!
            
            self.saveCategory(category: todoCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            newCategoryText = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - tableview delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Press + to add watchlist"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "gotoItems", sender: self)
        
    }
    
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoItems" {
            
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                destinationVC.selectedCategory = categories![indexPath.row]
            }
        }
    }
 
}
