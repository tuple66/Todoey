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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        // Do any additional setup after loading the view, typically from a nib.

        
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
        //Call save function when toggled
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
        
        
    //MARK = Model Manilupulation Methods
        
        func saveItems(){
            let encoder = PropertyListEncoder()
            
            do {
                let data = try encoder.encode(itemArray)
                try data.write(to: dataFilePath!)
            } catch {
                print("Error encoding item array \(error)")
                
            }
            tableView.reloadData()
            }
        
        
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print ("Error decoding item array")
            }
        }
        
       
        
        
        
    }
    
        
    
    
    
}

