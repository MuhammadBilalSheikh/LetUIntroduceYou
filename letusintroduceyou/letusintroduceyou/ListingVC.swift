//
//  Listing.swift
//  letusintroduceyou
//
//  Created by Admin on 07/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ListingVC:UIViewController  , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableViewPlaceListing: UITableView!
    var user:AppUser?;
    var propertiesArray:[Property] = [Property]();
    override func viewDidLoad() {
        self.navigationItem.title = "Property Listing"
        self.user = AppUser.getInst();
        tableViewPlaceListing.delegate = self;
        tableViewPlaceListing.dataSource = self;
        tableViewPlaceListing.rowHeight = UITableViewAutomaticDimension
        tableViewPlaceListing.showsVerticalScrollIndicator = false
        //tableViewPlaceListing.estimatedRowHeight = 200;
        // Create a nib for reusing
        let nib = UINib(nibName: "PropertyListCell", bundle: nil)
        tableViewPlaceListing.register(nib, forCellReuseIdentifier: "PropertyListCell")
        //
    }
    override func viewWillAppear(_ animated: Bool) {
        getAllPlaces();
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true);
        let prop = propertiesArray[indexPath.row];
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PropertyProfileVC") as! PropertyProfileVC;
        vc.property = prop;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //////// Swipe -> add to favourities START/////////////////////////////////
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            let prop = self.propertiesArray[index.item]
            print(prop.id!);
            let params:Parameters = [
                "user_type": self.user!.currentUserType!,
                "user_id":self.user!.userId!,
                "mob":"true",
                "property_id":prop.id!
            ];
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
            Alamofire.request(URLs.PROPERTY_FAV_ADD, method: .post, parameters: params).responseString(completionHandler: { (data) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false;
                
                switch(data.result){
                case .success(let res):
                    print(res);
                    let msg =  res.contains("success") ? "Property added to favourities successfully." : "Property already added to favourities." ;
                    self.showMessage(title: "Adding to favourities", message: msg, doneButtonText: "OK", cancelButtonText: nil, done: {
                        print("done")
                    }, cancel: nil);
                    break;
                case .failure(let error):
                    print(error)
                    self.showMessage(title: "Adding to favourities", message: "Network error while adding property to favourites.", doneButtonText: "OK", cancelButtonText: nil, done: {
                        print("done")
                    }, cancel: nil);
                    break;
                }
            });
            tableView.setEditing(false, animated: true);
        }
        favorite.backgroundColor = UIColor(red: 25/255, green: 193/255, blue: 208/255, alpha: 1)
        return [favorite]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    /////////// Swipe -> add to favourites END /////////////////////////////
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertiesArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyListCell", for: indexPath) as! PropertyListCell;
        let property = propertiesArray[indexPath.row];
        cell.propertyName.text = property.title;
        cell.address.setBoldAndRegularTitle(boldString: "Address: ", regularString: property.address ?? "Not Available", boldFontSize: 14, regularFontSize: 12)
        cell.area.setBoldAndRegularTitle(boldString: "Area: ", regularString: "\(property.landArea ?? "0.0") \(property.unit ?? "N/A")", boldFontSize: 14, regularFontSize: 12)
        // property.descrip ?? "Not Available"
        cell.desc.setBoldAndRegularTitle(boldString: "Description: ", regularString: property.descrip ?? "Not Available", boldFontSize: 14, regularFontSize: 12)
        
        cell.bedCount.text = property.bed ?? "N/A"
        cell.showerCount.text = property.bath ?? "N/A"
        cell.propertyImage.applyListingShadow();
        if let firstImage = property.imagesURL?[0]{
            do{
                let url = try firstImage.asURL()
                cell.propertyImage.showLoadingSd();
                cell.propertyImage.sd_setImage(with: url)
            }catch{
                print("Cant Convert URL")
            }
        }
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        return cell;
    }
    /*
     let json = JSON(data: data);
     
    let user  = User(json: json["user"]);
     
     
     */
    
    
    
    func getAllPlaces(){
        let parameters : Parameters =
            [
                "user_type": self.user!.currentUserType!,
                "user_id":self.user!.userId!,
                "mob":"true"
        ];
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        Alamofire.request(URLs.PROPERTY_LISTING,method: .post, parameters: parameters).responseString( completionHandler: { res in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            switch(res.result){
                case .success(let rawData):
                    if let data = rawData.data(using: .utf8, allowLossyConversion: false) {
                        let propArr = JSON(data)["properties"];
                        if propArr != JSON.null {
                            if self.propertiesArray.count == 0{
                            for prop in propArr.array!{
                                self.propertiesArray.append(Property(json: prop));
                                print(prop)
                            }
                            
                            self.tableViewPlaceListing.reloadData();
                            }
                        }else{
                            self.showMessage(title: rawData, message: "", doneButtonText: "Okey", cancelButtonText: nil, done: {
                                //self.getAllPlaces();
                            }, cancel: {
                                //print("Proceed")
                            });
                        }
                    }else{
                    
                    }
                break;
                case .failure:
                    if self.propertiesArray.count == 0 {
                    self.showMessage(title: "Network Error", message: "Cannot fetch data from internet please try again later.", doneButtonText: "Retry Now", cancelButtonText: "Cancel", done: {
     //////////////////// Dummy Data Start////////////////////////////
                        if Constants.isDummyMode {
                        let propArr = JSON(Constants.DUMMY_PROP.data(using: .utf8, allowLossyConversion: false)!).array;
                        //if propArr != JSON.null {
                        print(propArr ?? "null array")
                            if self.propertiesArray.count == 0{
                                for prop in propArr!{
                                    self.propertiesArray.append(Property(json: prop));
                                    print(prop)
                                }

                                self.tableViewPlaceListing.reloadData();
                            }
                        }else{
                                self.getAllPlaces();
                        }
   ///////////////////// Dummy DATA End ////////////////////////
                    
                    
                    }, cancel: {
                        print("Proceed")
                    });
                    }
                break;
            }
            
        });
        
    }
    
    
    
}
