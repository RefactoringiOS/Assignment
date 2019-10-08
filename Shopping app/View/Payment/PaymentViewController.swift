//
//  PaymentViewController.swift
//  Shopping app
//
//  Created by KOVIGROUP on 04/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var toaltLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fxCurrency: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var model = SingletonManager.model
    @IBOutlet weak var testLabe: UILabel!
    var currency = [Currency]()
    var activeCurrency = 0
    let baseURL = "https://www.freeforexapi.com/api/live?pairs=USD"
    let currencySelected = ["AUD", "CAD","EUR","GBP","JPY","NZD","PLN","USD"]
    let currencySymbol = ["$","$","€","£","¥","$","zł","$"]
    var currencychange = ""
    var finalURL = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderTableView.dataSource = self
        self.orderTableView.delegate = self
        orderTableView.tableFooterView = UIView()
        configureCheckout()
        apiUrlCurrency()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.selectRow(5, inComponent:0, animated:false)
        finalURL = baseURL + currencySelected[7]
        currencychange = currencySymbol[7]
        fetchData { (dict, error) in
            debugPrint(dict as Any)
        }
        currencyPicker.selectRow(7, inComponent:0, animated:false)
    }
    func fetchData(completion: @escaping ([String:Any]?, Error?) -> Void) {
        let url = URL(string: finalURL)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let rates = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                        self.currency = [Currency]()
                    let data = rates["rates"] as! NSDictionary
                    
                    print("&@",data)
            
    completion(rates, nil)
                    
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencySelected.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencySelected[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencySelected[row]
        fxCurrency.text = currencySymbol[row]
        fetchData { (dict, error) in
            debugPrint(dict as Any)
        }
        toaltLabel.text = fxCurrency.text! + String(format: "%.2f", model.calculateCartTotal())
    }
        func apiUrlCurrency() {
        do {
            if let file = URL(string: finalURL) {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    if (object["rates"] as? [[String:Any]]) != nil {
                } else if let object = json as? [Any] {
                    for anItem in object as! [Dictionary<String, AnyObject>] {
                        let rates = anItem["rates"] as! String
                        let rate = anItem["rate"] as! Double
                         //self.toaltLabel.text = as! Double
                        _ = Currency(rates: rates, rate: rate )
                    }
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        orderTableView.reloadData()
    }
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? CheckingViewController {
            controller.tableView.reloadData()
        }
    }
    
    func configureCheckout() {
        toaltLabel.text = fxCurrency.text! + String(format: "%.2f", model.calculateCartTotal())
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
        cell.totalLabel.text = String(Int(model.basket[indexPath.row][1])) + fxCurrency.text! + String(format: "%.2f", model.basket[indexPath.row][2])
        
        return cell
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
            let error = "Oops! Something  wrong. Please try again later."
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
