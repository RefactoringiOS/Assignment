//
//  DetailsViewController.swift
//  Shopping app
//
//  Created by KOVIGROUP on 04/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    let model = SingletonManager.model
    var productItem: Product?
    var originalPrice: Double?
    var subTotalPrice: Double = 0.0
    var totalPrice: Double = 0.0
    var quantity: Int = 1
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = self.productItem, let price = originalPrice{
            self.configureView(for: product, with: price)
            subTotalPrice = price
            totalPrice = price
        }
    }
    
    func configureView(for product: Product, with price: Double) {
        productImage.image = UIImage(named: (product.image)!)
        self.productName.text = product.name
        self.productPrice.text = "$" + String(format: "%.2f", price)
        self.quantityLabel.text = "Quantity: " + String(quantity)
    }
    
    @IBAction func quantityStepper(_ sender: UIStepper) {
        quantity = Int(sender.value)
        updateTotalPrice()
    }
    
    func updateTotalPrice() {
        if let product = self.productItem {
            totalPrice = subTotalPrice * Double(quantity)
            configureView(for: product, with: totalPrice)
        }
    }
    
    @IBAction func addToBasket(_ sender: Any) {
        if let product = self.productItem {
       model.addToCart(product: product, quantity: Double(quantity), totalPrice: totalPrice)
        }
        showAlertMsg("Successful", message: "Item added to basket.", time: 1)
    }
    
       var alertController: UIAlertController?
       var alertTimer: Timer?
       var remainingTime = 0.0
       var baseMessage: String?
    
    func showAlertMsg(_ title: String, message: String, time: Double) {
        guard (self.alertController == nil) else {
            return
        }
        self.baseMessage = message
        self.remainingTime = time
        self.alertController = UIAlertController(title: title, message: self.baseMessage, preferredStyle: .alert)
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    @objc func countDown() {
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        } else {
            self.alertController!.message = self.alertMessage()
        }
    }
    
    func alertMessage() -> String {
        var message=""
        if let baseMessage=self.baseMessage {
            message=baseMessage+" "
        }
        return(message)
    }
}
