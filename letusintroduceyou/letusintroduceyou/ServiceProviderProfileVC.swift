//
//  ServiceProviderProfileVC.swift
//  letusintroduceyou
//
//  Created by Admin on 24/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import Alamofire
import SwiftyJSON

class ServiceProviderProfileVC: UIViewController {
    var serviceProvider:ServiceProvider?;
    var serviceProviderID:String?;
//    -"title": "Dubai Buses",
//    -"address": "UAE",
//    -"description": "Bus Service",
//    -"timing": "",
//    -"suburb": "Mirdif",
//    "city": "Dubai",
//    "country": "",
//    -"rating": 0,
//    -"phone": "800 90 90",
//    -"email": "",
//    -"category": "Public transport",
//    -"image": "https://letusintroduceyou.com/images/nearplaces/"
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var suburbLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var headerBg: UIImageView!
    let user = AppUser.getInst();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.applyListingShadow()
        self.navigationItem.title = "Service Provider Profile"
        headerBg.applyListingShadow()
        if serviceProvider != nil {
            setData();
        }else{
            getDataFromInternetWithID();
        }
        
    }

    func setData()  {
        titleLabel.text = serviceProvider?.title ?? "N/A"
        cityLabel.text = serviceProvider?.address ?? "N/A"
        phoneLabel.text = serviceProvider?.phone ?? "N/A"
        categoryLabel.text = serviceProvider?.category ?? "N/A"
        emailLabel.text = serviceProvider?.email ?? "N/A"
        suburbLabel.text = serviceProvider?.suburb ?? "N/A"
        timingLabel.text = serviceProvider?.timing ?? "N/A"
        descriptionLabel.text = serviceProvider?.descrip ?? "N/A"
        if let val = serviceProvider?.rating{
            ratingView.rating = val
            print(val)
        }
        if let image =  serviceProvider?.image{
            profileImage.showLoadingSd();
            profileImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile_img"))
        }
        ratingView.didFinishTouchingCosmos = {rating in
            self.showMessage(title: "Rated", message: "You've rated \(rating), but unfortunately rating feature is not available right now.", doneButtonText: "Okey", cancelButtonText: nil, done: {
                print("Done")
            }, cancel: nil)
        }
    }
    
    
    func getDataFromInternetWithID() {
        let params = ["service_provider_id":serviceProviderID!,
                    "user_id": user.userId!,
                    "user_type":user.currentUserType!
        ];
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        Alamofire.request(URLs.SERVICE_PROVIDER , method: .post, parameters: params).responseString(completionHandler: {data in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            switch(data.result){
            case .success(let response):
                //print("\(response)");
                if let d = response.data(using: .utf8, allowLossyConversion: false) {
                    self.serviceProvider = ServiceProvider(json: JSON(d));
                    self.setData();
                }
                break;
            case .failure(let error):
                print("\(error)");
                self.showMessage(title: "Network Error", message: "Please try again later.", doneButtonText: "Retry", cancelButtonText: "Cancel", done: {
                    self.getDataFromInternetWithID();
                }, cancel: {
                    print("Cancel");
                })
                break;
            }
        })
        
        
    }
    
}
