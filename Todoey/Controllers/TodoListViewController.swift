//
//  ViewController.swift
//  Todoey
//
//  Created by David Bowles on 18/07/2018.
//  Copyright © 2018 David Bowles. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let  realm = try! Realm()
    var todoItem : Results<Item>?
    
    // when its delegate changes its value it is updated here
    
    var selectedCategory : Category? {
        didSet{
          loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItem?[indexPath.row] {
        cell.textLabel?.text = item.title
        //Ternary Operator
        // value = conditioin ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if let count = todoItem?.count {
         return  count
       } else {
        return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = todoItem?[indexPath.row]{
                do {
                    
                    try realm.write {
                        realm.delete(item  )
                    }
                } catch {
                    print("Error saving done status, \(error)")
                }
                tableView.reloadData()
            }
        }
    }
    
 
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItem?[indexPath.row]{
            do {
                
                try realm.write {
                   item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            tableView.reloadData()
        }
        

        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add NEw Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What happens when the action is pressed
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newitem = Item()
                        newitem.title = textField.text!
                        newitem.createdDate = NSDate()
                        currentCategory.items.append(newitem)
                       
                    }
                } catch {
                    print("Error saving items, \(error)")
                }
            }
           self.tableView.reloadData()
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
        
    
    func loadItems() {
        todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
        tableView.reloadData()
    }
    
    
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
        
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




    

