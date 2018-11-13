//
//  FavouriteViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 11/23/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class FavouriteViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.favourites.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Model.favourites.count == 0 {
            return tableView.frame.height
        } else {
            return 102
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Model.favourites.count == 0 {
            let cell = UITableViewCell()
            let nofavlabel = UILabel(frame: CGRect(x: tableView.frame.width / 2.0 - 100.0, y: tableView.frame.width / 2.0 - 20.0, width: 100.0, height: 20.0))
            nofavlabel.text = "No favourite"
            cell.addSubview(nofavlabel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "product-cell", for: indexPath) as! ProductTableViewCell
            let i = indexPath.row
            let favoriteProduct = Model.favourites[i]
            cell.productName.text = favoriteProduct.product.name
            cell.productImage.image = favoriteProduct.product.image
            cell.storeName.text = favoriteProduct.store.name
            cell.storeLocation.text = favoriteProduct.store.location
            return cell
        }
    }

}
