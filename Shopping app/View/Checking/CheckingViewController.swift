//
//  CheckingViewController.swift
//  Shopping app
//
//  Created by KOVIGROUP on 04/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit

class CheckingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let model = SingletonManager.model
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        displayTotal()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.basket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath) as! BasketCell
        cell.nameLabel.text = model.products[Int(model.basket[indexPath.row][0])].name
        cell.quantityLabel.text = "Quantity: " + String(Int(model.basket[indexPath.row][1]))
        cell.priceLabel.text = "$" + String(format: "%.2f", model.basket[indexPath.row][2])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            managedContext.delete(model.storedCart[indexPath.row])
            self.model.storedCart.remove(at: indexPath.row)
            self.model.basket.remove(at: indexPath.row)
            
            do
            {
                try managedContext.save()
                tableView.reloadData()
                displayTotal()
            }
            catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            if model.basket.count == 0 {
                self.editButton.title = "Edit"
                self.tableView.setEditing(false, animated: true)
            }
        }
    }
    
    func displayTotal() {
        self.totalLabel.text = "$" + String(format: "%.2f", model.calculateCartTotal())
    }
    
    @IBAction func editTable(_ sender: UIBarButtonItem) {
        if model.basket.count > 0 {
            if self.tableView.isEditing {
                sender.title = "Edit"
                self.tableView.setEditing(false, animated: true)
            } else {
                sender.title = "Done"
                self.tableView.setEditing(true, animated: true)
            }
        }
    }
    
    @IBAction func checkout(_ sender: UIButton) {
        if model.basket.count == 0 {
            let alert = UIAlertController.init(title: "Your basket is empty", message: "Please add an product in your cart before you checkout.", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.performSegue(withIdentifier: "Checkout", sender: sender)
        }
    }
}
