//
//  MallTableViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 9/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit
import FirebaseDatabase
import BTNavigationDropdownMenu

class MallTableViewController: CardTableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar:UISearchBar!
    var db:FIRDatabaseReference!
    var menuView:BTNavigationDropdownMenu!
    var filteredMalls:[Mall] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.title = "Loading..."
        SetupMenuView(title: "Loading", items: [])
        db = FIRDatabase.database().reference()
        FetchMallInformation()
    }
    
    
    //MARK: BTNAvigationDropdownMenu
    func SetupMenuView(title:String,items:[AnyObject]) {
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: (self.navigationController?.view)!, title: title, items: items)
        menuView.cellTextLabelColor = .black
        menuView.cellSelectionColor = .gray
        menuView.cellTextLabelAlignment = .center
        menuView.cellSeparatorColor = .gray
        menuView.arrowTintColor = .gray
        menuView.didSelectItemAtIndexHandler = {
            (index:Int) in
            self.MenuViewDidSelectItemAt(index: index)
        }
        menuView.isUserInteractionEnabled = false
        self.navigationItem.titleView = menuView
    }
    
    func MenuViewDidSelectItemAt(index:Int) {
        Model.activeCity = Model.cities[index]
        self.title = Model.activeCity?.name
        if let malls = Model.activeCity?.malls {
            self.filteredMalls = malls
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func HeightForRowAt(indexPath: IndexPath) -> CGFloat {
        return 300
    }
    override func NumberOfRows(section:Int) -> Int {
        if searchBar.text == "" {
            if let city = Model.activeCity {
                return city.malls.count
            }
        } else {
            return filteredMalls.count
        }
        return 0
    }
    
    override func CellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        if searchBar.text == "" {
            if let city = Model.activeCity {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "mall-cell", for: indexPath) as? MallTableViewCell {
                    cell.Setup()
                    
                    let i = indexPath.row
                    let mall = city.malls[i]
                    cell.mallName.text = mall.name
                    cell.mallImage.image = UIImage(named: "mall-placeholder")
                    if let img = city.malls[i].featureImage {
                        cell.mallImage.image = img
                    } else {
                        cell.mallImage.DownloadImageFromStorage(link: mall.linkImage, completion: {
                            (img) in
                            city.malls[i].featureImage = img
                        })
                    }
                    cell.mallLocation.text = mall.street
                    return cell
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "mall-cell", for: indexPath) as? MallTableViewCell {
                let i = indexPath.row
                let mall = filteredMalls[i]
                cell.mallName.text = mall.name
                
                cell.mallImage.image = #imageLiteral(resourceName: "mall-placeholder")
                if let img = filteredMalls[i].featureImage {
                    cell.mallImage.image = img
                }
                cell.mallLocation.text = mall.street
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredMalls = self.filteredMalls.filter({
            (mall) in
            return mall.name.lowercased().contains((searchBar.text?.lowercased())!)
        })
        self.tableView.reloadData()
    }
    
 

    //MARK: Connectivity
    func FetchMallInformation() {
        isLoading = true
        db.child("cities").observeSingleEvent(of: .value, with: { (snapshot) in
            if let cities = snapshot.value as? NSDictionary {
                for city in cities {
                    if let cityDict = city.value as? NSDictionary {
                        let newCity = City(data: cityDict)
                        newCity.id = city.key as? String ?? ""
                        Model.cities.append(newCity)
                        Model.citiesName.append(newCity.name)
                    }
                }
                if Model.citiesName.count > 0 {
                    self.isLoading = false
                    self.SetupMenuView(title: Model.citiesName[0], items: Model.citiesName as [AnyObject])
                    
                    Model.activeCity = Model.cities[0]
                    self.title = Model.activeCity?.name
                    self.navigationItem.titleView?.isUserInteractionEnabled = true
                    if let malls = Model.activeCity?.malls {
                        self.filteredMalls = malls
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }
        })
    }

}
