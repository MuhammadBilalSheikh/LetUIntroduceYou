//
//  Constants.swift
//  letusintroduceyou
//
//  Created by Admin on 06/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let USER_TYPE_UI2SRV = ["Service Provider":"ServiceProvider" , "Agent":"Agent","Supplier":"Supplier","General User":"GeneralUser","Buyer":"Buyer"];
    static let USER_TYPE_SRV2UI = ["ServiceProvider":"Service Provider" , "Agent":"Agent","Supplier":"Supplier","GeneralUser":"General User" , "Buyer":"Buyer"];
    static let USER_TYPE = ["GeneralUser" , "Agent" , "Supplier" , "ServiceProvider" , "Buyer"];
    enum UserType: String {
        case ServiceProvider , Agent, Supplier, GeneralUser , Buyer
    }
    
    static let isDummyMode = false;
    
    static let DUMMY_PROP = "[{\"title\": \"Property Name\",\"price\": \"356,000 €\",\"address\": \"address lorem ipsum dolor sit amet\",\"description\": \"Description Lorem ipsum dolor sit amet\",\"land_area\": \"600\",\"unit\": \"Square Yards\",\"bed\": \"5\",\"bath\": \"4\",\"dining_rooms\": \"3\",\"store_rooms\": \"4\",\"laundry\": \"2\",\"maids_rooms\": \"2\",\"country\": \"Afghanistan\",\"city\": \"A Coruña (La Coruña)\",\"lat\": \"24.861\",\"lng\": \"67.01\",\"suburb\": \"\",\"orwner\": \"Arsalan Yousuf\",\"images\": [\"https://letusintroduceyou.com/images/property_images/13727992121499062622.png\"],\"neighbor_images\": [\"https://letusintroduceyou.com/images/neighbor_images/7323653431499062600.png\"],\"ownership_images\": [\"https://letusintroduceyou.com/images/owner_images/4672519001499062571.jpg\"],\"utility_images\": [\"https://letusintroduceyou.com/images/utility_images/18415447681499062569.jpg\"]},{ \"bed\" : \"4\",\"laundry\" : \"1\",\"description\" : \"The House can be viewed upon request. Because of its fine location and a nice outlook along with fine construction details, we cannot guarantee that it will remain on the market for long.\",\"orwner\" : \"Moosa Baluch\",\"title\" : \"10 Marla Brand New House\",\"maids_rooms\" : 0,\"images\" : [\"https://letusintroduceyou.com/images/property_images/469251741501064103.jpg\"],\"city\" : \"Lahore\",\"ownership_images\" : [\"https://letusintroduceyou.com/images/owner_images/19099155131501064131.png\"],\"lng\" : \"74.373\",\"price\" : \"212,500 €\",\"unit\" : \"Marla\",\"land_area\" : \"10\",\"country\" : \"Pakistan\",\"bath\" : \"4\",\"lat\" : \"31.475\",\"address\" : \"DHA Phase 6 - Block A, Lahore.\",\"neighbor_images\" : [\"https://letusintroduceyou.com/images/neighbor_images/517063501501064117.jpg\"],\"suburb\" : \"\",\"store_rooms\" : \"1\",\"dining_rooms\" : \"1\",\"utility_images\" : [\"https://letusintroduceyou.com/images/utility_images/17110947431501064124.jpg\"],\"id\" : \"5\"},{ \"bed\" : \"4\",\"laundry\" : \"1\",\"description\" : \"The House can be viewed upon request. Because of its fine location and a nice outlook along with fine construction details, we cannot guarantee that it will remain on the market for long.\",\"orwner\" : \"Moosa Baluch\",\"title\" : \"10 Marla Brand New House\",\"maids_rooms\" : 0,\"images\" : [\"https://letusintroduceyou.com/images/property_images/469251741501064103.jpg\"],\"city\" : \"Lahore\",\"ownership_images\" : [\"https://letusintroduceyou.com/images/owner_images/19099155131501064131.png\"],\"lng\" : \"74.373\",\"price\" : \"212,500 €\",\"unit\" : \"Marla\",\"land_area\" : \"10\",\"country\" : \"Pakistan\",\"bath\" : \"4\",\"lat\" : \"31.475\",\"address\" : \"DHA Phase 6 - Block A, Lahore.\",\"neighbor_images\" : [\"https://letusintroduceyou.com/images/neighbor_images/517063501501064117.jpg\"],\"suburb\" : \"\",\"store_rooms\" : \"1\",\"dining_rooms\" : \"1\",\"utility_images\" : [\"https://letusintroduceyou.com/images/utility_images/17110947431501064124.jpg\"],\"id\" : \"5\"}]";
    
    static let APP_COLOR = UIColor.init(red: 25/255, green: 193/255, blue: 208/255, alpha: 1);
}
