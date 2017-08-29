//
//  Supplier.swift
//  letusintroduceyou
//
//  Created by Admin on 07/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class Supplier: NSObject {

    var id:String?;
    var name:String?;
    var address:String?;
    var descrip:String?;
    var contact:String?;
    var city:String?;
    var rating:Double?;
    var country:String?;
    
    /*
     {
     "id": "1",
     "name": "SupplierArsal",
     "address": "lorem ipsum dolor sit amet",
     "description": "description Lorem ipsum dolor sit amet",
     "contact": "123456789",
     "country": "Pakistan",
     "city": "Karachi",
     "rating": 0
     }
     
     */
    init(json:JSON){
        super.init();
        id = json["id"].string;
        name = json["name"].string;
        address = json["address"].string
        descrip = json["description"].string
        contact = json["contact"].string
        city = json["city"].string
        rating = json["rating"].double
        country = json["country"].string
        
    }
    
    
}
