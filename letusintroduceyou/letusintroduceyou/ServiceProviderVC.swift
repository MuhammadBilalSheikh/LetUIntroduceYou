//
//  ServiceProviderVC.swift
//  letusintroduceyou
//
//  Created by Admin on 07/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ServiceProviderVC: UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    var user:AppUser?;
    var serviceProvidersArray:[ServiceProvider] = [ServiceProvider]();
    var pageCount = 1;
    var isRequested:[Int:Bool]?;
    
    
    override func viewDidLoad() {
        showError(isError: false, isNetworkError: false)
        self.navigationItem.title = "Service Provider"
        self.user = AppUser.getInst();
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        //tableViewPlaceListing.estimatedRowHeight = 200;
        // Create a nib for reusing
        let nib = UINib(nibName: "ServiceProviderCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ServiceProviderCell")
        isRequested = [Int:Bool]();
        retryButton.addTarget(self, action: #selector(ServiceProviderVC.getAllProviders), for: .touchUpInside)
        getAllProviders();
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true);
        let sp = serviceProvidersArray[indexPath.row];
        print(sp);
        let spProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceProviderProfileVC") as! ServiceProviderProfileVC;
        spProfileVC.serviceProvider = sp ;
        self.navigationController?.pushViewController(spProfileVC, animated: true);
        return;
    }
   
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceProvidersArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceProviderCell", for: indexPath) as! ServiceProviderCell;
        let provider = serviceProvidersArray[indexPath.row];
        cell.serviceProviderName.text = provider.title;
        cell.location.text = provider.address ?? "Not Available"
        cell.phone.setBoldAndRegularTitle(boldString: "Phone: ", regularString: provider.phone ?? "Not Available", boldFontSize: 12, regularFontSize: 12)
        cell.rating.text = String(describing: provider.rating ?? 0);
        cell.descriptionLabel.setBoldAndRegularTitle(boldString: "Description: ", regularString: provider.descrip ?? "Not Available", boldFontSize: 12, regularFontSize: 12);
        cell.suburbLabel.setBoldAndRegularTitle(boldString: "Suburb: ", regularString: provider.suburb ?? "Not Available", boldFontSize: 12, regularFontSize: 12);
        cell.profileImage.applyListingShadow();
        if let image =  provider.image{
            cell.profileImage.showLoadingSd();
            cell.profileImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile_img"))
        }
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        if ((self.serviceProvidersArray.count - 1) == indexPath.row ){
            let bool:Bool = isRequested![pageCount] ?? false;
            print(isRequested ?? "No Data")
            if (!bool) {
                isRequested?[pageCount] = true;
                self.pageCount += 1;
                print("Get Request")
            }
            getAllProviders();
        }
        return cell;
    }
    
    
    
    func getAllProviders(){
        retryButton.isEnabled = false;
        let parameters : Parameters =
            [
                "user_type": self.user!.currentUserType!,
                "user_id":self.user!.userId!,
                "mob":"true"
        ];
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        Alamofire.request(URLs.SERVICE_PROVIDER_LISTING+"?page=\(pageCount)",method: .post, parameters: parameters)
            .responseString( completionHandler: { res in
                self.retryButton.isEnabled = true;
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            switch(res.result){
            case .success(let rawData):
                print(rawData)
                if let data = rawData.data(using: .utf8, allowLossyConversion: false) {
                    let prov = JSON(data);
                    if prov != JSON.null {
                        self.showError(isError: false, isNetworkError: false)
                        if self.serviceProvidersArray.count <= (self.pageCount*10)-10{
                            print("Items in List \(self.serviceProvidersArray.count)")
                            print("Items in Response\(prov.array?.count ?? 0) - Page Count \(self.pageCount)")
                            for sp in prov.array!{
                                self.serviceProvidersArray.append(ServiceProvider(json: sp));
                            }
                            self.tableView.reloadData();
                        }else{
                        print("Data Skipped: \(self.serviceProvidersArray.count == (self.pageCount*10)-10) \(self.serviceProvidersArray.count) == \((self.pageCount*10)-10)")
                        }
                    }else{
                        if self.serviceProvidersArray.count<1{
                            self.showError(isError: true, isNetworkError: false)
                        }
                    }
                }else{
                    if self.serviceProvidersArray.count<1{
                        self.showError(isError: true, isNetworkError: false)
                    }
                }
                break;
            case .failure:
                if self.serviceProvidersArray.count <= (self.pageCount*10)-10 {
//                    self.showMessage(title: "Network Error", message: "Cannot fetch data from internet please try again later.", doneButtonText: "Retry Now", cancelButtonText: "Cancel", done: {
//                        self.getAllProviders();
//                    }, cancel: {
//                        print("Proceed")
//                    });
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
