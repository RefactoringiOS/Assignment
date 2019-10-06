//
//  Model.swift
//  Shopping app
//
//  Created by KOVIGROUP on 05/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit
import CoreData

class Model: NSObject {
    var products = [Product]()
    var storedProducts = [NSManagedObject]()
    var basket = [[Double]]()
    var storedCart = [NSManagedObject]()
    
    override init() {
        super.init()
        loadProducts()
        loadCart()
        getProducts()
    }
    
    func loadProducts() {
//        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
//        do {
//            let results = try managedContext.fetch(fetchRequest)
//            storedProducts = results as! [NSManagedObject]
//            if storedProducts.count > 0 {
//                for index in 0...storedProducts.count - 1 {
//                    let binaryData = storedProducts[index].value(forKey: "image") as! Data
//                    let image = UIImage(data: binaryData)
//                    let name = storedProducts[index].value(forKey: "name") as! String
//                    let price = storedProducts[index].value(forKey: "price") as! Double
//                    let quantity = storedProducts[index].value(forKey: "details") as! String
//                    let loadedProduct = Product(price: price, name: name, quantity: quantity, image: image)
//                    products.append(loadedProduct)
//                    
//                }
//            }
//        }
//        catch let error as NSError
//        {
//            print("Could not load. \(error), \(error.userInfo)")
//        }
    }

    func checkForProduct(_ searchItem: Product) -> Int {
        var targetIndex = -1
        if products.count > 0 {
            for index in 0...products.count - 1 {
                if products[index].name == searchItem.name {
                    targetIndex = index
                }
            }
        }
        return targetIndex
    }
    
    func addItemToList(_ newProduct: Product!, imageURL: String) {
        
//        if checkForProduct(newProduct) == -1 {
//            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            let picture = UIImageJPEGRepresentation(loadImage)
//            let entity = NSEntityDescription.entity(forEntityName: "Products", in: managedContext)
//            let productToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
//            productToAdd.setValue(newProduct, forKey: "image")
//            productToAdd.setValue(newProduct.name, forKey: "name")
//            productToAdd.setValue(newProduct.price, forKey: "price")
//            do
//            {
//                try managedContext.save()
//            }
//            catch let error as NSError
//            {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//
//            storedProducts.append(productToAdd)
//            //newProduct.image = UIImage(data: !)
//            products.append(newProduct)
//
//        }
    }
    
    func loadCart() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Basket")
        
        do {
            
            let results = try managedContext.fetch(fetchRequest)
            storedCart = results as! [NSManagedObject]
            
            if storedCart.count > 0 {
                for index in 0...storedCart.count - 1 {
                    
                    let product = storedCart[index].value(forKey: "product") as! Double
                    let quantity = storedCart[index].value(forKey: "quantity") as! Double
                    let totalPrice = storedCart[index].value(forKey: "total") as! Double
                    
                    let temp = [product, quantity, totalPrice]
                    
                    basket.append(temp)
                    
                }
            }
        }
        catch let error as NSError
        {
            print("Could not load. \(error), \(error.userInfo)")
        }
        
    }
    
    func addToCart(product: Product, quantity: Double, totalPrice: Double) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Basket", in: managedContext)
        let productToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
        productToAdd.setValue(checkForProduct(product), forKey: "product")
        productToAdd.setValue(quantity, forKey: "quantity")
        productToAdd.setValue(totalPrice, forKey: "total")
        
        do
        {
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        let temp = [Double(checkForProduct(product)), quantity, totalPrice]
        
        storedCart.append(productToAdd)
        basket.append(temp)
        
    }
    
    func clearCart() {
        
        basket.removeAll()
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Basket")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do
        {
            try managedContext.execute(request)
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func calculateCartTotal() -> Double{
        var total = 0.0
        if self.basket.count > 0 {
            for index in 0...self.basket.count - 1 {
                total += basket[index][2]
            }
        }
        return total
    }
    
    func getProducts() {
            if let jsonFile = Bundle.main.path(forResource: "Products", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: jsonFile), options: .dataReadingMapped)
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonDictionary = json as? [String:Any] {
                        if let productsArray = jsonDictionary["Products"] as? [[String:Any]] {
                            self.products = [Product]()
                            for
                                productItem in productsArray {
                                    let name = productItem["name"] as! String
                                    let price = productItem["price"] as! Double
                                    let details = productItem["quantity"] as! String
                                    let image = productItem ["image"]as! String
                                    let allProducts = Product(price: price, name: name, quantity: details, image: image )
                                    self.products.append(allProducts)
                            }
                        }
                    }
                } catch {
                    print(error)
            }
        }
    }
    
    func purchase(product: Product, quantity: Int, total: Double) -> Bool{
        var urlString = "Success"
        urlString += "&total=" + String(total)
        return true
        
    }
}
