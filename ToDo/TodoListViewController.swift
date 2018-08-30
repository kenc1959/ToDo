//
//  ViewController.swift
//  ToDo
//
//  Created by ChanKenneth King Yan on 2018/8/29.
//  Copyright © 2018年 CQLOGIC. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.phist")
    
    //let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print(dataFilePath)
        
        loadItems()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let item = indexPath.row
        
        cell.textLabel?.text = itemArray[item].todoText
        
        cell.accessoryType = itemArray[item].done ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            itemArray[indexPath.row].done = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemArray[indexPath.row].done = true
        }
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var newItemText = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks the Add Item button on our UIAlert
            // print(newItemText.text!)
            let todoItem = TodoItem()
            
            todoItem.todoText = newItemText.text!
            
            self.itemArray.append(todoItem)
            
            //self.defaults.setValue(self.itemArray, forKey: "newTodoListArray")
        
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            newItemText = alertTextField
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("Error encoding todoItem array \(error)")
        }
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error loading todoItems from phist \(error)")
            }
        }
        
    }
    
}

