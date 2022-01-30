//
//  ViewController.swift
//  Todoey
//
//  Created by AbdooMaaz's playground on 22.12.21.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //item.done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
}

// MARK: - Actions
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        
        //      Delete items onSelect and YES ORDER MATTERS
        //      context.delete(itemArray[indexPath.row])
        //      itemArray.remove(at: indexPath.row)
        saveItems()
    }
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Todey Item ", message: "", preferredStyle: .alert)
        
        let action  = UIAlertAction(title: "Add new Item", style: .default) { action in
            
            if let safeText = textfield.text {
                if !safeText.isEmpty {
                    
                    let newItem = Item(context: self.context)
                    newItem.title = safeText
                    newItem.done = false
                    self.itemArray.append(newItem)
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
}


// MARK: - Fetch & Save Items
extension TodoListViewController {
    //        Commented out is using Codable .plist
    func saveItems() {
        //        let encoder = PropertyListEncoder()
        
        do {
            //            let data = try encoder.encode(self.itemArray)
            //            try data.write(to: self.dataFilePath!)
            try self.context.save()
        }
        catch {
            //          print("Error encoding item array: \(error)")
            print("Error Saving item array: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with req: NSFetchRequest<Item> = Item.fetchRequest()){
        //        if  let data = try? Data(contentsOf: dataFilePath!) {
        //            let decoder = PropertyListDecoder()
        
        //        let req : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(req)
            //              itemArray = try decoder.decode([Item].self, from: data)
        }
        catch{
            //                print("Error when decoding item Array: \(error)")
            print("Error when Fetching Items: \(error)")
        }
        //        }
        tableView.reloadData()
    }

}


// MARK: - SearchBarDelegare
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        }
        else {
            if let searchText = searchBar.text {
                let request: NSFetchRequest<Item> = Item.fetchRequest()
                request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                loadItems(with: request)
            }
        }
    }
}
