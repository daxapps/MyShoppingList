//
//  ShoppingListTableVC.swift
//  MyShoppingList
//
//  Created by Jason Crawford on 2/23/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableVC: UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<ShoppingList>!
    
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        populateShoppingLists()
        
    }
    
    private func populateShoppingLists() {
        
        let request = NSFetchRequest<ShoppingList>(entityName: "ShoppingList")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultsController.delegate = self
        
        try! self.fetchResultsController.performFetch()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .insert {
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        } else if type == .delete {
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let shoppingList = self.fetchResultsController.object(at: indexPath)
            self.managedObjectContext.delete(shoppingList)
            try! self.managedObjectContext.save()
            
        }
        
        self.tableView.isEditing = false
    }


    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 44))
        headerView.backgroundColor = UIColor.lightText
        
        let textField = UITextField(frame: headerView.frame)
        textField.placeholder = "Enter Shopping List"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height:0))
        textField.leftViewMode = .always
        textField.delegate = self
        
        headerView.addSubview(textField)
        
        return headerView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let shoppingList = NSEntityDescription.insertNewObject(forEntityName: "ShoppingList", into: self.managedObjectContext) as! ShoppingList
        shoppingList.title = textField.text
        
        try! self.managedObjectContext.save()
        textField.text = ""
        
        return textField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let shoppingList = self.fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = shoppingList.title
        
        return cell 
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
