//
//  Property.swift
//  letusintroduceyou
//
//  Created by Admin on 04/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON;

class Property: NSObject {
    
    var id:String?;
    var title : String?;
    var price: String?;
    var address: String?;
    var descrip:String?;
    var landArea:String?;
    var unit:String?;
    var bed:String?;
    var bath:String?
    var diningRooms: String?;
    var storeRooms:String?;
    var laundry:String?;
    var maidsRooms:String?;
    var country:String?;
    var city: String?;
    var lat: String?;
    var lng: String?;
    var suburb:String?;
    var orwnerName:String?;
    var imagesURL: [String]?;
    var neighborImagesURL: [String]?
    var ownershipImagesURL:[String]?
    var utilityImagesURL: [String]?
    
    override init() {
        super.init()
    }
    /*
     {
     "title": "Property Name",
     "price": "356,000 €",
     "address": "address lorem ipsum dolor sit amet",
     "description": "Description Lorem ipsum dolor sit amet",
     "land_area": "600",
     "unit": "Square Yards",
     "bed": "5",
     "bath": "4",
     "dining_rooms": "3",
     "store_rooms": "4",
     "laundry": "2",
     "maids_rooms": "2",
     "country": "Afghanistan",
     "city": "A Coruña (La Coruña)",
     "lat": "24.861",
     "lng": "67.01",
     "suburb": "",
     "orwner": "Arsalan Yousuf",
     "images": [
     "https://letusintroduceyou.com/images/property_images/13727992121499062622.png"
     ],
     "neighbor_images": [
     "https://letusintroduceyou.com/images/neighbor_images/7323653431499062600.png"
     ],
     "ownership_images": [
     "https://letusintroduceyou.com/images/owner_images/4672519001499062571.jpg"
     ],
     "utility_images": [
     "https://letusintroduceyou.com/images/utility_images/18415447681499062569.jpg"
     ]
     }
     
     */
    init(json:JSON) {
        super.init()
        self.title = json["title"].string;
        self.id = json["id"].string;
        self.price = json["price"].string;
        self.address = json["address"].string;
        self.descrip = json["description"].string;
        self.landArea = json["land_area"].string;
        self.unit = json["unit"].string;
        self.bed = json["bed"].string;
        self.bath = json["bath"].string;
        self.diningRooms = json["dining_rooms"].string
        self.storeRooms = json["store_rooms"].string
        self.laundry = json["laundry"].string
        self.maidsRooms = json["maids_rooms"].string
        self.country = json["country"].string
        self.city = json["city"].string
        self.lat = json["lat"].string
        self.lng = json["lng"].string
        self.suburb = json["suburb"].string
        self.orwnerName = json["owner"].string
        self.imagesURL = [String]()
        for image in json["images"].arrayValue{
            self.imagesURL!.append(image.string!);
        }
        self.neighborImagesURL = [String]();
        for nImages in json["neighbor_images"].arrayValue{
            self.neighborImagesURL!.append(nImages.string!);
        }
        self.ownershipImagesURL = [String]();
        for oImages in json["ownership_images"].arrayValue{
            self.ownershipImagesURL!.append(oImages.string!);
        }
        self.utilityImagesURL = [String]();
        for uImages in json["utility_images"].arrayValue{
            self.utilityImagesURL!.append(uImages.string!);
        }
        
    }

}
