//
//  ViewController.swift
//  Todoey
//
//  Created by David Bowles on 18/07/2018.
//  Copyright © 2018 David Bowles. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    //var itemArray = ["Buy crisps", "Buy Milk", "Buy potatoes" ]
    let defaults = UserDefaults.standard
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Buy crisps"
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "Buy Milk"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Buy Potatoes"
        itemArray.append(newItem3)

        
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
        
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
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    //MARK - Add NEw Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What happens when the action is pressed
            let newitem = Item()
            newitem.title = textField.text!
            self.itemArray.append(newitem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
        
    
    
    
}

