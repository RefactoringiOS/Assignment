//
//  ProductsTableViewCell.swift
//  Shopping app
//
//  Created by KOVIGROUP on 04/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {
    @IBOutlet  weak var productImageView: UIImageView!
    @IBOutlet  weak var descriptionLabel: UILabel!
    @IBOutlet  weak var priceLabel: UILabel!
    @IBOutlet  weak var units: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWith(product: Product) {
        let viewModel = ProductViewModel(product: product)
        if let _ = viewModel.image {
            self.imageView!.image = viewModel.image
        }
    }
}
