//
//  ViewController.swift
//  Todoey
//
//  Created by AbdooMaaz's playground on 22.12.21.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        itemArray.append(Item(title: "test", done: true))
        super.viewDidLoad()
        if let itemArray = defaults.array(forKey: "TodoListArray") as? [Item] {
            self.itemArray = itemArray
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        var item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //item.done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK - add new Items

    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Todey Item ", message: "", preferredStyle: .alert)
        
        let action  = UIAlertAction(title: "Add new Item", style: .default) { action in
            
            if let safeText = textfield.text {
                if !safeText.isEmpty{
                    self.itemArray.append(Item (title:safeText,done: false))
                    self.defaults.set(self.itemArray, forKey: "TodoListArray")
                    self.tableView.reloadData()
                }
            }
        }
         
        alert.addTextField { alertTextField in
            alertTextField.placeholder  = "Create new Todoey"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

