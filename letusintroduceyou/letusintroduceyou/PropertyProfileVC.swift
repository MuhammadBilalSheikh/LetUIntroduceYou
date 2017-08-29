//
//  PropertyProfileVC.swift
//  letusintroduceyou
//
//  Created by Admin on 27/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import SwiftyJSON
import Alamofire

class PropertyProfileVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    
    var property:Property?;
    var propertyID:String?;
    
    @IBOutlet weak var collectionViewPictures: UICollectionView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var propertyTitle: UILabel!
    @IBOutlet weak var bedroomsCountLabel: UILabel!
    @IBOutlet weak var dinningCountLabel: UILabel!
    @IBOutlet weak var storeCountLabel: UILabel!
    @IBOutlet weak var bedRoomsLabel: UILabel!
    @IBOutlet weak var diningRoomsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bathroomCountLabel: UILabel!
    @IBOutlet weak var washRoomLabel: UILabel!
    @IBOutlet weak var storeRoomsLabel: UILabel!
    @IBOutlet weak var maidRoomsLabel: UILabel!
    @IBOutlet weak var laundryCount: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var backgroundProperty: UIImageView!
    
    var imagesArray : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Collection View  Data / Layout / Style
        let nib = UINib(nibName: "ImageViewCell", bundle: nil)
        collectionViewPictures.register(nib, forCellWithReuseIdentifier: "ImageViewCell")
        
        collectionViewPictures.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ImageViewCell")
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        layout.itemSize = CGSize(width: screenWidth / 3.5, height: screenWidth / 3.5)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectionViewPictures.setCollectionViewLayout(layout, animated: false)
        collectionViewPictures.delegate = self
        collectionViewPictures.dataSource = self
        //--------------------------------Collection View Details End---------------------------
        //self.navigationItem.backBarButtonItem?.title = "CK"
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil);
        self.navigationItem.title = "Property Details"
        if property != nil {
            propertyID = property?.id;
            setData();
        }else{
            getDataFromInternetWithID();
        }
    }
    
    func getDataFromInternetWithID() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(URLs.PROPERTY_BY_ID, method: .post, parameters: ["property_id":propertyID!]).responseString(completionHandler: {da in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch(da.result){
            case .success(let res):
                if let data = res.data(using: .utf8, allowLossyConversion: false) {
                    self.property = Property(json: JSON(data));
                    self.setData();
                }
                break;
            case .failure(let err):
                self.showMessage(title: "Network Error", message: "Please try again.", doneButtonText: "Retry", cancelButtonText: "Cancel", done: {
                    self.getDataFromInternetWithID()
                }, cancel: {
                    print("Network Error Cancel \(err)");
                })
                break;
            }
        
        })
  
    }

    func setData()  {
        
        areaLabel.text = "\(property?.landArea ?? "--") \(property?.unit ?? " N/A")"
        propertyTitle.text = property?.title ?? "N/A"
        bedroomsCountLabel.text = property?.bed ?? "N/A";
        dinningCountLabel.text = property?.diningRooms ?? "N/A"
        storeCountLabel.text = property?.storeRooms ?? "N/A"
        bathroomCountLabel.text = property?.bath ?? "N/A"
        descriptionLabel.text = property!.descrip ?? "Not available"
        laundryCount.text = property!.laundry ?? "N/A"
        maidRoomsLabel.text = "\(property!.maidsRooms ?? "N/A")"
        storeRoomsLabel.text = property!.storeRooms ?? "N/A"
        diningRoomsLabel.text = property!.diningRooms ?? "N/A"
        bedRoomsLabel.text = property!.bed ?? "N/A"
        washRoomLabel.text = property!.bath ?? "N/A"
        ratingView.rating = 4.0;
        
        //Adding All Images in one Array to show in Collection View
        for s in (property?.imagesURL)!{
            imagesArray.append(s);
        }
        for s in (property?.utilityImagesURL)!{
            imagesArray.append(s);
        }
        for s in (property?.neighborImagesURL)!{
            imagesArray.append(s);
        }
        for s in (property?.ownershipImagesURL)!{
            imagesArray.append(s);
        }
        ///// End of Adding images in array for collection View
        
        /// Header Image Background
        if let image =  property?.imagesURL?[0]{
            backgroundProperty.showLoadingSd();
            backgroundProperty.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile_header_bg"))
        }
        print(imagesArray.count)
        collectionViewPictures.reloadData()

    }
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell;
        let image =  imagesArray[indexPath.row]
        cell.image.showLoadingSd();
        cell.image.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile_header_bg"))
        cell.image.applyListingShadow()
        print(imagesArray[indexPath.row])
        
        let height : CGFloat = collectionViewPictures.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
        self.view.setNeedsLayout()
        //self.view.layoutIfNeeded()
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Row \(indexPath.row)")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number Section \(imagesArray.count)")
        return imagesArray.count;
    }
    
    
}
