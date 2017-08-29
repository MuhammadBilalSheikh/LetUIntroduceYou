//
//  FavouritePropertyVC.swift
//  letusintroduceyou
//
//  Created by Admin on 03/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FavouritePropertyVC: UIViewController , UITableViewDelegate , UITableViewDataSource{

    //Data
    var propertyArray = [Property]();
    var isRequested:[Int:Bool] = [Int:Bool]();
    var user:AppUser?;
     var pageCount = 1;
    
    ///Views
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showError(isError: false, isNetworkError: false)
        self.navigationItem.title = "Favourite Property"
        self.user = AppUser.getInst();
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        //tableViewPlaceListing.estimatedRowHeight = 200;
        // Create a nib for reusing
        let nib = UINib(nibName: "PropertyListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PropertyListCell")
        errorButton.addTarget(self, action: #selector(FavouritePropertyVC.getFavProperties), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // if propertyArray.count < 1{
        pageCount = 1
        propertyArray.removeAll()
        tableView.reloadData()
        getFavProperties();
        //}
    }
    
    
    func getFavProperties(){
        errorButton.isEnabled = false;
        let parameters : Parameters =
            [
                "user_type": self.user!.currentUserType!,
                "user_id":self.user!.userId!,
                "mob":"true"
        ];
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        Alamofire.request(URLs.PROPERTY_FAV_LISTING+"?page=\(pageCount)",method: .post, parameters: parameters)
            .responseString( completionHandler: { res in
                self.errorButton.isEnabled = true;
                UIApplication.shared.isNetworkActivityIndicatorVisible = false;
                switch(res.result){
                case .success(let rawData):
                    print(rawData)
                    if let data = rawData.data(using: .utf8, allowLossyConversion: false) {
                        //let prov = JSON(data);
                         let propArr = JSON(data)["properties"];
                        if propArr != JSON.null {
                            self.showError(isError: false, isNetworkError: false)
                            if self.propertyArray.count <= (self.pageCount*10)-10{
                                print("Items in List \(self.propertyArray.count)")
                                print("Items in Response\(propArr.array?.count ?? 0) - Page Count \(self.pageCount)")
                                
                                for sp in propArr.array!{
                                    self.propertyArray.append(Property(json: sp));
                                }
                                
                                self.tableView.reloadData();
                            }else{
                                print("Data Skipped: \(self.propertyArray.count == (self.pageCount*10)-10) \(self.propertyArray.count) == \((self.pageCount*10)-10)")
                            }
                        }else{
                            if self.propertyArray.count<1{
                                self.showError(isError: true, isNetworkError: false)
                            }
                        }
                    }else{
                        if self.propertyArray.count<1{
                            self.showError(isError: true, isNetworkError: false)
                        }
                    }
                    break;
                case .failure:
                    //if self.propertyArray.count <= (self.pageCount*10)-10 {
                    if self.propertyArray.count < 1{
                        self.showError(isError: true, isNetworkError: true)
                    }
                    print("Netwrok Error \(self.pageCount)")
                    break;
                }
                
            });
        

    }
    
    
    ///// Table View Functionality Start
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true);
        let prop = propertyArray[indexPath.row];
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PropertyProfileVC") as! PropertyProfileVC;
        vc.property = prop;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyListCell", for: indexPath) as! PropertyListCell;
        let property = propertyArray[indexPath.row];
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
        if ((self.propertyArray.count - 1) == indexPath.row ){
            let bool:Bool = isRequested[pageCount] ?? false;
            print(isRequested )
            if (!bool) {
                isRequested[pageCount] = true;
                self.pageCount += 1;
                print("Get Request")
            }
            getFavProperties();
        }

        return cell;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyArray.count;
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            let prop = self.propertyArray[index.item]
            print(prop.id!);
            let params:Parameters = [
                "user_type": self.user!.currentUserType!,
                "user_id":self.user!.userId!,
                "mob":"true",
                "property_id":prop.id!
            ];
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
            Alamofire.request(URLs.PROPERTY_FAV_DEL, method: .post, parameters: params).responseString(completionHandler: { (data) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false;
                
                switch(data.result){
                case .success(let res):
                    print(res);
                    if(res.contains("success")){
                        if self.propertyArray.count == 1{
                            self.pageCount = 1;
                        }
                        self.propertyArray.remove(at: index.item)
                        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    }else{
                    self.showMessage(title: "Deleting from favourities", message: "Fail to delete from favourities." , doneButtonText: "OK", cancelButtonText: nil, done: {
                        print("done")
                    }, cancel: nil);
                    }
                    break;
                case .failure(let error):
                    print(error)
                    self.showMessage(title: "Deleting from favourities", message: "Network error while deleting property from favourites.", doneButtonText: "OK", cancelButtonText: nil, done: {
                        print("done")
                    }, cancel: nil);
                    break;
                }
                self.tableView.reloadData()
            });

            //tableView.setEditing(false, animated: true);
        }
        action.backgroundColor = UIColor.red;
        
        return [action];
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    // Table View Functionality End
    
    ///Error
    func showError(isError:Bool , isNetworkError:Bool)  {
        tableView.isHidden = isError
        messageView.isHidden = !isError
        errorLabel.isHidden = !isError
        errorButton.isHidden = !isNetworkError
        if isError {
            errorLabel.text = isNetworkError ? "Cannot fetch data from internet, Tap retry button to try again." : "No data available"
        }
    }

}
