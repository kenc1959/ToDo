//
//  ViewController.swift
//  ToDo
//
//  Created by ChanKenneth King Yan on 2018/8/29.
//  Copyright © 2018年 CQLOGIC. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.phist")
    // cannot use AppDelegate.persistentContainer.viewContext directly - use singleton UIApplication instead
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }    //let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // print(dataFilePath)
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
    
        //request.predicate = NSPredicate(format: "parentCategory CONTAINS[cd] %@", selectedCategory.name!)
        
        //loadItems(with: request)

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let item = indexPath.row
        
        cell.textLabel?.text = itemArray[item].title
        
        cell.accessoryType = itemArray[item].done ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /* Delete order is important
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        */
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            itemArray[indexPath.row].done = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemArray[indexPath.row].done = true
        }
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var newItemText = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks the Add Item button on our UIAlert
            
            let todoItem = Item(context: self.context)
            
            todoItem.title = newItemText.text!
            todoItem.done = false
            todoItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(todoItem)
            
            //self.defaults.setValue(self.itemArray, forKey: "newTodoListArray")
        
            self.saveItems()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            newItemText = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
            
        } catch {
            print("Error core data save: \(error)")
        }
        
        self.tableView.reloadData()
    }
 
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
        
            itemArray = try context.fetch(request)
        
        } catch {
        
            print("Error loading data from context \(error)")
        
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar method

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //print(searchBar.text!)

        //see NSPredicate cheatsheet url: academy.realm.io/posts/nspredicate-cheatsheet
        //url: nshipster.com/nspredicate
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
        loadItems(with: request, predicate: request.predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
 
        }
    }
}
