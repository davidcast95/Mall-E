//
//  SearchViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 9/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var filteredProducts = Array<Product>()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchBar.text == "" {
            return Model.products.count
        } else {
            return filteredProducts.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product-cell", for: indexPath) as! ProductTableViewCell
        if searchBar.text == "" {
            let i = indexPath.row
            let product = Model.products[i]
            let store = Model.stores[i]
            cell.productName.text = product.name
            cell.productImage.image = product.image
            cell.storeName.text = store.name
            cell.storeLocation.text = store.location
        } else {
            let i = indexPath.row
            let product = filteredProducts[i]
            let store = Model.stores[i]
            cell.productName.text = product.name
            cell.productImage.image = product.image
            cell.storeName.text = store.name
            cell.storeLocation.text = store.location
            
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                FilterProduct(searchBar.text!)
    }
    
    func FilterProduct(_ search:String) {
        filteredProducts = Model.products.filter({
            product in
            return product.name.lowercased().contains(search.lowercased())
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }

}
