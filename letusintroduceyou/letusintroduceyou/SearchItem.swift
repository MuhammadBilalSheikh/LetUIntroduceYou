//
//  SearchItem.swift
//  letusintroduceyou
//
//  Created by Admin on 10/08/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchItem: NSObject {
    public static let SERVICE_PROVIDER = 0;
    public static let PROPERTY = 1;
    public static let SUPPLIER = 2;
    static let toUiData = [
    0:"Service Provider",
    1:"Property",
    2:"Supplier"
    ];
/*
     {
        "data": [
            {
                "type": "service_provider",
                "name": "abc",
                "icon": "https://letusintroduceyou.com/images/nearplaces/",
                "id": "4"
            },
            {
                "type": "properties",
                "name": "10 Marla Brand New House",
                "icon": "https://letusintroduceyou.com/images/property_images/469251741501064103.jpg",
                "id": "5"
            },
            {
                "type": "suppliers",
                "name": "Arsalan Yousuf",
                "icon": "https://letusintroduceyou.com/images/not_found.png",
                "id": "1"
            }
        ]
     }
     */
    
    var nameTitle:String?;
    var icon:String?;
    var id:String?;
    var type:Int?;
    
    init(json:JSON) {
        self.nameTitle = json["name"].string
        self.icon = json["icon"].string
        self.id = json["id"].string
        if let t = json["type"].string {
            self.type = t.contains("suppliers") ? SearchItem.SUPPLIER : (t.contains("properties") ? SearchItem.PROPERTY:SearchItem.SERVICE_PROVIDER);
        }
    }
}
