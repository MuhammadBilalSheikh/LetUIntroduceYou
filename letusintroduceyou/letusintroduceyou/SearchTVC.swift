//
//  SearchTVC.swift
//  letusintroduceyou
//
//  Created by Admin on 07/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SearchTVC: UITableViewController , UISearchResultsUpdating {

    var arr = [String]();
    var filteredArr = [String]();
    var alamoRequest:DataRequest?;
    var searchViewController : UISearchController?;
    let searchResultController = UITableViewController();
    let user = AppUser.getInst();
    var searchArray = [SearchItem]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultController.tableView.delegate = self;
        self.searchResultController.tableView.dataSource = self;
        self.navigationItem.title = "Search"
        self.searchViewController = UISearchController(searchResultsController: self.searchResultController);
        self.tableView.tableHeaderView = self.searchViewController?.searchBar;
        self.searchViewController?.searchResultsUpdater = self;
        self.searchViewController?.dimsBackgroundDuringPresentation = false
        let nib = UINib(nibName: "SearchItemCell", bundle: nil)
        self.searchResultController.tableView.register(nib, forCellReuseIdentifier: "SearchItemCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.searchResultController.hideKeyboardWhenTappedAround();
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        definesPresentationContext = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arr = CoreData.getInst().getAllSearchQueries();
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        alamoRequest?.suspend()
        let url = URLs.SEARCH_API+"user_type="+user.currentUserType!+"&term="+searchController.searchBar.text!;//user_type=Buyer&term=a
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        alamoRequest = Alamofire.request(url, method: .get).responseString(completionHandler: {data in
            self.searchArray.removeAll();
            self.searchResultController.tableView.reloadData();
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            switch(data.result){
            case .success(let res):
                if let data = res.data(using: .utf8, allowLossyConversion: false) {
                    if (JSON(data)["data"] != JSON.null){
                        let array = JSON(data)["data"].array;
                        for item in array!{
                            self.searchArray.append(SearchItem(json: item));
                        }
                        self.searchResultController.tableView.reloadData();
                    }
                }
                break
            case .failure(let err):
                print(err)
                break
            }
        });
        alamoRequest?.resume();
    }

   

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.tableView {
            print("Before Searching... numberOfRowsInSection")
            return self.arr.count;
        }
        print("After Searching...")
        return self.searchArray.count;
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        if tableView == self.tableView {
            print("Clicked : \(self.arr[indexPath.row])")
            self.searchArray.removeAll()
            self.searchResultController.tableView.reloadData()
            self.searchViewController?.searchBar.text = self.arr[indexPath.row];
            self.searchViewController?.isActive = true
        }else{
            let item = self.searchArray[indexPath.row];
            switch item.type! {
            case SearchItem.PROPERTY:
                print("Property")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PropertyProfileVC") as! PropertyProfileVC;
                vc.propertyID = item.id;
                self.navigationController?.pushViewController(vc, animated: true)
                break;
            case SearchItem.SERVICE_PROVIDER:
                print("Service Provider")
                let spProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceProviderProfileVC") as! ServiceProviderProfileVC;
                spProfileVC.serviceProviderID = item.id;
                self.navigationController?.pushViewController(spProfileVC, animated: true);
                break;
            case SearchItem.SUPPLIER:
                print("Supplier")
                let supplierVC = self.storyboard?.instantiateViewController(withIdentifier: "SupplierProfileVC") as! SupplierProfileVC;
                supplierVC.supplierID = item.id;
                self.navigationController?.pushViewController(supplierVC, animated: true);
                break;
            default:
                print("No Action");
        
                break;
            }
            
            if CoreData.getInst().saveSearchQuery(query: (self.searchViewController?.searchBar.text)!){
                arr = CoreData.getInst().getAllSearchQueries();
                self.tableView.reloadData();
            }
            
            print("Clicked : \(self.searchArray[indexPath.row].nameTitle ?? "Value NULL") ")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell = UITableViewCell();
            print("Before Searching... cellForRowAt")
            cell.textLabel?.text = arr[indexPath.row]
            return cell;
        }else{
            let arr = self.searchArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCell") as! SearchItemCell;
            print("After Searching... cellForRowAt")
            cell.nameLabel.text = arr.nameTitle
            cell.hintLabel.text = SearchItem.toUiData[arr.type!]
            
            cell.iconImage.applyListingShadow();
            if let image = arr.icon{
                do{
                    let url = try image.asURL()
                    cell.iconImage.showLoadingSd();
                    cell.iconImage.sd_setImage(with: url)
                }catch{
                    print("Cant Convert URL")
                }
            }
            return cell;
        }
    }
    
}
