//
//  ViewController.swift
//  Todoey
//
//  Created by AbdooMaaz's playground on 22.12.21.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        itemArray.append(Item(title: "test", done: true))
        super.viewDidLoad()
        loadItems()
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
        saveItems()
    }
    
    //MARK - add new Items

    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Todey Item ", message: "", preferredStyle: .alert)
        
        let action  = UIAlertAction(title: "Add new Item", style: .default) { action in
            
            if let safeText = textfield.text {
                if !safeText.isEmpty{
                    self.itemArray.append(Item (title:safeText,done: false))
                    self.saveItems()
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
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }
        catch{
            print("Error encoding item array: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        if  let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error when decoding item Array: \(error)")
            }
        }
    }
}

