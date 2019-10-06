//
//  ShopViewController.swift
//  Shopping app
//
//  Created by KOVIGROUP on 04/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let model = SingletonManager.model
    var products: [Product]?
    var timeArray: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        readJson()
    }
}

extension ShopViewController {
    func readJson() {
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
                                self.products?.append(allProducts)
                        }
                        if let _ = self.products {
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
    }
}

extension ShopViewController: UITableViewDelegate,UITableViewDataSource {
    private func tableView(_ tableView: UITableView, didSelectItemAt indexPath: IndexPath) {
       if indexPath.row == 0 {
            if let channel = self.products?[indexPath.section - 1] {
                print(channel)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductsTableViewCell
        cell.descriptionLabel.text = products?[indexPath.row].name
        cell.units.text = products?[indexPath.row].quantity
        cell.priceLabel.text = String(format: "$%.2f", products?[indexPath.row].price ?? 4)
        cell.productImageView.image = UIImage(named: (products?[indexPath.row].image)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Details" {
        let indexPath = self.tableView?.indexPath(for: sender as! ProductsTableViewCell )
        let detailView = segue.destination as! DetailsViewController
        let product = products![indexPath!.row]
        detailView.productItem = product
        detailView.originalPrice = product.price
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.destination is DetailsViewController {
            
        }
    }
}
