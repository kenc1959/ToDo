//
//  ViewController.swift
//  ToDo
//
//  Created by ChanKenneth King Yan on 2018/8/29.
//  Copyright © 2018年 CQLOGIC. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    
    var items : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = items![indexPath.row].title
            cell.accessoryType = items![indexPath.row].done ? .checkmark : .none
            print(item)
        } else {
            cell.textLabel?.text = "Press + to add Symbol to watchlist"
            cell.accessoryType = .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let symbolItem = items?[indexPath.row] {
            
            do {
                try realm.write {
                    symbolItem.done = !symbolItem.done
                    /* delete is also simple
                    realm.delete(symbolItem)
                    */
                }
            } catch {
                print("Error updating item \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var newItemText = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks the Add Item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {

                do {
                    try self.realm.write {
                        let symbolItem = Item()
                        symbolItem.title = newItemText.text!
                        currentCategory.items.append(symbolItem)
                    }
                } catch {
                    print("Error writing to realm \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Symbol"
            newItemText = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
 
    func loadItems() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search bar method

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
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
