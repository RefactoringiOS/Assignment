//
//  Product.swift
//  Shopping app
//
//  Created by KOVIGROUP on 05/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import Foundation
 
class Product: CustomStringConvertible {
    var price: Double
    var name: String
    var quantity: String
    var image: String?
    
    init(price: Double, name: String, quantity:String, image:String ) {
        self.price = price
        self.name = name
        self.quantity = quantity
        self.image = image
    }
    var description: String {
        return "Products \(self.price) - \(self.name) - \(self.quantity) - \(String(describing: self.image))"
    }
}
