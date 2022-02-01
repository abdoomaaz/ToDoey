//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by AbdooMaaz's playground on 31.01.22.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories  = [Category]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        return cell
    }
    
    // MARK: - ACTIONS
    
    @IBAction func addCategory(_ sender: Any) {
        var textfield = UITextField()
        
        let alert =  UIAlertController (title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action  = UIAlertAction (title: "Add new Item", style: .default) { action in
            if let safeText  = textfield.text {
                if !safeText.isEmpty{
                    let newCategory = Category(context: self.context)
                    newCategory.name = textfield.text
                    self.categories.append(newCategory)
                    self.saveCategories()
                }
            }
        }
        alert.addTextField { alertTextFieled in
            alertTextFieled.placeholder = "Create new Category"
            textfield = alertTextFieled
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.parentCategory = categories[indexPath.row]
        }
    }
    
    // MARK: - Fetch & Save Categories
    func saveCategories() {
        do {
            try self.context.save()
        }
        catch{
            print("Error Saving Categories: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        let req : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(req)
            tableView.reloadData()
        }
        catch {
            print("Error when Fetching Categories")
        }
    }
}
