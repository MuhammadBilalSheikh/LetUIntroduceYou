//
//  ServiceProvider.swift
//  letusintroduceyou
//
//  Created by Admin on 07/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class ServiceProvider: NSObject {
    
    var id:String?;
    var title:String?;
    var address:String?;
    var descrip:String?;
    var timing:String?;
    var suburb:String?;
    var city:String?;
    var country:String?;
    var lat:Double?;
    var lng:Double?;
    var rating:Double?;
    var phone:String?;
    var email:String?;
    var category:String?;
    var image:String?;

    /*
     {
     "id": "20",
     "title": "Dubai Buses",
     "address": "UAE",
     "description": "Bus Service",
     "timing": "",
     "suburb": "Mirdif",
     "city": "Dubai",
     "country": "",
     "lat": 0,
     "lng": 0,
     "rating": 0,
     "phone": "800 90 90",
     "email": [moosa.bh@gmail.com,bilal@gmail.com],
     "category": "Public transport",
     "image": "https://letusintroduceyou.com/images/nearplaces/"
     }
     */
    init(json:JSON) {
        super.init()
        self.id = json["id"].string;
        self.title = json["title"].string;
        self.address = json["address"].string;
        self.descrip = json["description"].string;
        self.timing = json["timing"].string;
        self.suburb = json["suburb"].string
        self.city = json["city"].string
        self.country = json["country"].string
        self.lat = json["lat"].double
        self.lng = json["lng"].double
        self.rating = json["rating"].double;
        self.phone = json["phone"].string;
        self.email = json["email"].string;
        self.category = json["category"].string;
        self.image = json["image"].string;
    }
}
