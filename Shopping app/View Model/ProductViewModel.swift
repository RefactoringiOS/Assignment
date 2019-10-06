//
//  ProductViewModel.swift
//  Shopping app
//
//  Created by KOVIGROUP on 05/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit

class ProductViewModel {
    var product: Product
    var quantityText: String
    var nameText: String
    var priceText: Double
    var image: UIImage?
    
    init(product: Product) {
        self.product = product
        self.quantityText = "Pr \(product.quantity)"
        self.nameText = "Pr.\(product.name)"
        self.priceText = product.price
        self.image = UIImage(named: product.image!.lowercased())
    }
}
