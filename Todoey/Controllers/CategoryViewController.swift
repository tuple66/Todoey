//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Bowles on 18/08/2018.
//  Copyright © 2018 David Bowles. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     load()
    }
    
    //MARK : TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        let category = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No Categories Added Yet"

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController

        //This line is telling the destination VC what the items are that need to be displayed

        if  let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }

    }
    
    
    
     // MARK : Data Manipulation Methods
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // What happens when the action is pressed
            
            let newcategory = Category()
            newcategory.name = textField.text!
            self.save(category: newcategory) // Call save function when data entered
            
        }
        
        alert.addTextField { (alertextField) in
            alertextField.placeholder = "Create new Category "
            //print(textField.text)
            textField = alertextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func save(category:Category){
        
        do {
            try  realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
            
        }
        tableView.reloadData()
    }
    
    //This function requires a paramater if type NSFetchRequest, if one is not provided then a default is used
    // This default calls a fetch request which isnt filtered so displays the complete list
        
//    func loadCategories(with request:NSFetchRequest<Categories> = Categories.fetchRequest()) {
//
//
//
//        do {
//            categoryArray  = try context.fetch(request)
//        } catch {
//            print ("Error fetching data from context \(error)")
//        }
//        tableView.reloadData()
//    }
    
    func load() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    
    }
    

    
 
    
    
    
    //MARK : Tableview Delegate methods
    
    
    
    
   
    
    
    
    
    
    

