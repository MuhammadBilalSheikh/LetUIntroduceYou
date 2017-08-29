//
//  SupplierVC.swift
//  letusintroduceyou
//
//  Created by Admin on 07/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SupplierVC: UIViewController , UITableViewDelegate , UITableViewDataSource{
   
    @IBOutlet weak var tableView: UITableView!
    var user:AppUser?;
    var suppliersArray:[Supplier] = [Supplier]();
    var pageCount = 1;
    var isRequested:[Int:Bool]?;
    
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        showError(isError: false, isNetworkError: false)
        self.navigationItem.title = "Suppliers"
        self.user = AppUser.getInst();
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        //tableViewPlaceListing.estimatedRowHeight = 200;
        // Create a nib for reusing
        let nib = UINib(nibName: "SupplierCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SupplierCell")
        isRequested = [Int:Bool]();
        getAllSuppliers();
        retryButton.addTarget(self, action: #selector(SupplierVC.getAllSuppliers), for: .touchUpInside)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true);
        let sp = suppliersArray[indexPath.row];
        print(sp);
        let spProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "SupplierProfileVC") as! SupplierProfileVC;
        spProfileVC.supplier = sp ;
        self.navigationController?.pushViewController(spProfileVC, animated: true);
        return;
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if let cell =  tableViewPlaceListing.cellForRow(at: indexPath){
    //            return cell.contentView.bounds.size.height;
    //        }else{
    //            return 200;
    //        }
    //  }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suppliersArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierCell", for: indexPath) as! SupplierCell;
        let supplier = suppliersArray[indexPath.row];
        cell.nameLabel.text = supplier.name;
        cell.locationLabel.setBoldAndRegularTitle(boldString: "Location: ", regularString: (supplier.address ?? "Not Available"), boldFontSize: 12, regularFontSize: 12)
        cell.contactLabel.setBoldAndRegularTitle(boldString: "Contact: ", regularString: supplier.contact ?? "Not Available", boldFontSize: 12, regularFontSize: 12)
        cell.descriptionLabel.setBoldAndRegularTitle(boldString: "Description: ", regularString:supplier.descrip ?? "Not Available", boldFontSize: 12, regularFontSize: 12);
        cell.countryLabel.setBoldAndRegularTitle(boldString: "City/Country: ", regularString: (
            "\(supplier.city ?? " - " ) , \(supplier.country ?? " - ")"), boldFontSize: 12, regularFontSize: 12)
        cell.profileImage.applyListingShadow();
        if let image =  supplier.descrip{
            print("Supplier No Image attribute in API")
            cell.profileImage.showLoadingSd();
            cell.profileImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile_img"))
        }
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        if ((self.suppliersArray.count - 1) == indexPath.row ){
            let bool:Bool = isRequested![pageCount] ?? false;
            print(isRequested ?? "No Data")
            if (!bool) {
                isRequested?[pageCount] = true;
                self.pageCount += 1;
                print("Get Request")
            }
            getAllSuppliers();
        }
        return cell;
    }
    
    
    
    func getAllSuppliers(){
        retryButton.isEnabled = false;
        let parameters : Parameters =
            [
                "user_type": self.user!.currentUserType!,
                "user_id":self.user!.userId!,
                "mob":"true"
        ];
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        Alamofire.request(URLs.SUPPLIERS_LISTING+"?page=\(pageCount)",method: .post, parameters: parameters)
            .responseString( completionHandler: { res in
                self.retryButton.isEnabled = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = false;
                switch(res.result){
                case .success(let rawData):
                    print("Network Response: \(rawData)")
                    if let data = rawData.data(using: .utf8, allowLossyConversion: false) {
                        let prov = JSON(data);
                        if prov != JSON.null {
                            self.showError(isError: false, isNetworkError: false)
                            if self.suppliersArray.count <= (self.pageCount*10)-10{
                                print("Items in List \(self.suppliersArray.count)")
                                print("Items in Response\(prov.array?.count ?? 0) - Page Count \(self.pageCount)")
                                for sp in prov.array!{
                                    self.suppliersArray.append(Supplier(json: sp));
                                }
                                self.tableView.reloadData();
                            }else{
                                print("Data Skipped: \(self.suppliersArray.count == (self.pageCount*10)-10) \(self.suppliersArray.count) == \((self.pageCount*10)-10)")
                            }
                        }else{
                            if self.suppliersArray.count<1{
                                self.showError(isError: true, isNetworkError: false)
                            }
                        }
                    }else{
                        if self.suppliersArray.count<1{
                            self.showError(isError: true, isNetworkError: false)
                        }
                    }
                    break;
                case .failure:
                    if self.suppliersArray.count <= (self.pageCount*10)-10 {
//                        self.showMessage(title: "Network Error", message: "Cannot fetch data from internet please try again later.", doneButtonText: "Retry Now", cancelButtonText: "Cancel", done: {
//                            self.getAllSuppliers();
//                        }, cancel: {
//                            print("Proceed")
//                        });
                        self.showError(isError: true, isNetworkError: true)
                    }
                    print("Netwrok Error \(self.pageCount)")
                    break;
                }
                
            });
        
    }
    
    func showError(isError:Bool , isNetworkError:Bool)  {
        tableView.isHidden = isError
        errorView.isHidden = !isError
        errorMessageLabel.isHidden = !isError
        retryButton.isHidden = !isError
        if isError {
            errorMessageLabel.text = isNetworkError ? "Cannot fetch data from internet, Tap retry button to try again." : "No data available, Tap retry button to try again."
        }
    }

}
