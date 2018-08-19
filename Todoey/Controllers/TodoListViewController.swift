//
//  ViewController.swift
//  Todoey
//
//  Created by David Bowles on 18/07/2018.
//  Copyright © 2018 David Bowles. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
    // when its delegate changes its value it is updated here
    
    var selectedCategory : Categories? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        print("called")
       
        //Ternary Operator
        // value = conditioin ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell

        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //Call save function when toggled
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add NEw Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What happens when the action is pressed
            
            let newitem = Item(context: self.context)
            newitem.title = textField.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            self.itemArray.append(newitem)
            self.saveItems() // Call save function when data entered
            
        }
        
        alert.addTextField { (alertextField) in
            alertextField.placeholder = "Create new item "
            //print(textField.text)
            textField = alertextField
        }
            
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
        
        
    //MARK: - Model Manilupulation Methods
        
        func saveItems(){
            
            do {
               try  context.save()
            } catch {
                print("Error saving context \(error)")
                
            }
            tableView.reloadData()
            }
        
      //This function requires a paramater if type NSFetchRequest, if one is not provided then a default is used
    // This default calls a fetch request which isnt filtered so displays the complete list
    
    //This method requires 2 inputs one for item and the other for a predicate.
    // If there is no first parameter then it is assigned a default of fetch request.
    //If there is no second parameter then it is assigne an optional nil
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil) {
        
        //This line takes the category name from the category view controller and checks its name
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
       
       //This block checks to see if there are additional filtering required on the item names, it is optional so needs to be unwrapped. If it doesnt exist, ie there is no item filtering then a fetch request is called
        if let additionalPredicate =  predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate] )
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
       itemArray  = try context.fetch(request)
        } catch {
            print ("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        //Set up a request as an NSFetchRequest and set the type to be of Item
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //Setup a predicate to searche for text in title that contains what is in the searchbar
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //set the request predicate to the search rules created above
       
        
        // setup the sorting to be ascending based on the title
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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




    

