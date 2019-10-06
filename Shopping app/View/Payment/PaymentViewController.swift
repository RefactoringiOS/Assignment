//
//  PaymentViewController.swift
//  Shopping app
//
//  Created by KOVIGROUP on 04/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var toaltLabel: UILabel!
    var model = SingletonManager.model
    var currencys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderTableView.dataSource = self
        self.orderTableView.delegate = self
        orderTableView.tableFooterView = UIView()
        configureCheckout()
        apiUrlCurrency()
        

    }
   
    override func viewDidAppear(_ animated: Bool) {
        orderTableView.reloadData()
    }
    
    func apiUrlCurrency() {
        guard let url = URL(string: "https://www.freeforexapi.com/api/live?pairs=EURGBP,USDJPY")
            else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? CheckingViewController {
            controller.tableView.reloadData()
        }
    }
    
    func configureCheckout() {
        toaltLabel.text = "$" + String(format: "%.2f", model.calculateCartTotal())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.basket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentCell
        
        cell.productLabel.text = model.products[Int(model.basket[indexPath.row][0])].name
        cell.totalLabel.text = String(Int(model.basket[indexPath.row][1])) + " x $" + String(format: "%.2f", model.basket[indexPath.row][2])
        
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    @IBAction func payNow(_ sender: Any) {
        let error = ""
       if error.isEmpty {
            
            showAlertMsg("Confirm Purchase", message: "Pay " + toaltLabel.text!, style: UIAlertController.Style.actionSheet)
        }
        else {
            showAlertMsg("Error", message: error, style: UIAlertController.Style.alert)
        }
        
    }
    
    var alertController: UIAlertController?
    func showAlertMsg(_ title: String, message: String, style: UIAlertController.Style) {
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        if style == UIAlertController.Style.actionSheet {
            alertController?.addAction(UIAlertAction(title: "Pay", style: .default, handler: { _ in
                self.checkout()
            }))
            alertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        } else {
            alertController?.addAction(UIAlertAction(title: "Okay", style: .default))
        }
        self.present(self.alertController!, animated: true, completion: nil)
        
    }
    
    func checkout() {
        var success = true
        for count in 0...self.model.basket.count - 1 {
            let product = self.model.products[Int(self.model.basket[count][0])]
            let quantity = Int(self.model.basket[count][1])
            let total = self.model.basket[count][2]
            let temp = model.purchase(product: product, quantity: quantity, total: total)
            if !temp {
                success = false
            }
        }
        
        if !success {
            let error = "Oops! Something went wrong. Please try again later."
            showAlertMsg("Error", message: error, style: UIAlertController.Style.alert)
        } else {
            print("Success! Checkout complete.")
            self.toaltLabel.text = "$0.00"
            self.model.clearCart()
            self.orderTableView.reloadData()
            self.performSegue(withIdentifier: "Finish", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = (segue.destination as! UINavigationController).topViewController as! ConfirmationViewController
    }
}
