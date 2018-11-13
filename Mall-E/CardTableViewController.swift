//
//  CardTableViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 6/8/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit



class CardTableViewController: UITableViewController {
    var isLoading = true
    
    func NumberOfRows(section:Int) -> Int {
        return 0
    }
    func NumberOfSections() -> Int {
        return 1
    }
    
    func CellForRowAt(indexPath:IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func HeightForRowAt(indexPath:IndexPath) -> CGFloat {
        return tableView.frame.size.height - 100
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .clear
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NumberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else {
            return NumberOfRows(section: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading {
            return tableView.frame.size.height - 100
        } else {
            return HeightForRowAt(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            if let loadingCell = tableView.dequeueReusableCell(withIdentifier: "loading") {
                return loadingCell
            } else {
                return UITableViewCell()
            }
        } else {
            return CellForRowAt(indexPath: indexPath)
        }
    }
    
    
    //MARK : ScrollView
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
