//
//  SupplierProfileVC.swift
//  letusintroduceyou
//
//  Created by Admin on 26/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON

class SupplierProfileVC: UIViewController {
    var supplier : Supplier?;
    var supplierID:String?;
    
//    "id": "1",
//    "name": "SupplierArsal",
//    "address": "lorem ipsum dolor sit amet",
//    "description": "description Lorem ipsum",
//    "contact": "123456789",
//    "country": "Pakistan",
//    "city": "Karachi",
//    "rating": 0

    @IBOutlet var nameLabel : UILabel?;
    @IBOutlet var addressLabel:UILabel?;
    @IBOutlet var descriptionLabel:UILabel?;
    @IBOutlet var contactLabel:UILabel?;
    @IBOutlet var cityCountryLabel:UILabel?;
    @IBOutlet var rating:CosmosView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Supplier Profile"
        
        if supplier != nil {
            setData();
        }else{
            getDataFromInternetWithID()
        }
    }
    
    func getDataFromInternetWithID()  {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(URLs.SUPPLIER_BY_ID, method: .post, parameters: ["supplier_id":self.supplierID!]).responseString(completionHandler: {data in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch(data.result){
            case .success(let res):
                if let a = res.data(using: .utf8, allowLossyConversion: false) {
                    self.supplier = Supplier(json: JSON(a));
                    self.setData();
                }
                break
            case .failure(let err):
                self.showMessage(title: "Network Error", message: "Please try again later", doneButtonText: "Retry", cancelButtonText: "Cancel", done: {
                    self.getDataFromInternetWithID()
                }, cancel: {
                    print("\(err)")
                })
                break
            }
        })
    }
    
    func setData()  {
        nameLabel?.text = supplier?.name ?? "N/A"
        addressLabel?.text = supplier?.address ?? "N/A"
        descriptionLabel?.text = supplier?.descrip ?? "N/A"
        contactLabel?.text = supplier?.contact ?? "N/A"
        cityCountryLabel?.text = "\(supplier?.city ?? "--" )/\(supplier?.country ?? "--" )";
        if let rated = supplier?.rating{
            rating?.rating = rated;
        }
        rating?.didFinishTouchingCosmos = {rating in
            self.showMessage(title: "Rated", message: "You've rated \(rating), but unfortunately rating feature is not available right now.", doneButtonText: "Okey", cancelButtonText: nil, done: {
                print("Done")
            }, cancel: nil)
        }
    }

    
}
