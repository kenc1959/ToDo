//
//  CategoryViewController.swift
//  ToDo
//
//  Created by ChanKenneth King Yan on 2018/8/31.
//  Copyright © 2018年 CQLOGIC. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
     //MARK - data source
    var categoryArray = [Category]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("category.phist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }
    
    //MARK - data manipulation
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

        do {
            
            categoryArray = try context.fetch(request)
            
        } catch {
            
            print("Error loading data from context \(error)")
            
        }
        tableView.reloadData()
    }
    
    func saveCategory() {
        do {
            try context.save()
            
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
            
            let todoCategory = Category(context: self.context)
            
            todoCategory.name = newCategoryText.text!
            
            self.categoryArray.append(todoCategory)
            
            self.saveCategory()
            
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
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
                
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
}
