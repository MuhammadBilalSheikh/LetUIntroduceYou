//
//  URLs.swift
//  letusintroduceyou
//
//  Created by Admin on 05/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

class URLs {
    static let DOMAIN_NAME : String = "https://letusintroduceyou.com";
    static let SIGN_UP : String  = DOMAIN_NAME + "/Apis/Site/signup";
    static let LOGIN : String = DOMAIN_NAME + "/Apis/Site/Login";
    static let UPDATE_PROFILE : String = DOMAIN_NAME + "/index.php/Users/changeUserBasicInfo" ;
    static let PROPERTY_LISTING : String = DOMAIN_NAME + "/Apis/Property/Listing";
    static let SERVICE_PROVIDER_LISTING :String = DOMAIN_NAME+"/Apis/Site/ServiceProvidersListing";//?page=n : n=1,2,3,4,5....
    
    static let SUPPLIERS_LISTING :String = DOMAIN_NAME+"/Apis/Supplier/SuppliersListing";//?page=n : n=1,2,3,4,5....
    static let PROPERTY_FAV_ADD : String = DOMAIN_NAME + "/Apis/Property/addMyFavProperty";
    static let PROPERTY_FAV_DEL : String = DOMAIN_NAME + "/Apis/Property/deleteMyFavProperty";
    static let PROPERTY_FAV_LISTING : String = DOMAIN_NAME + "/Apis/Property/MyFavProperties";//?page=n : n=1,2,3,4,5....
    static let SEARCH_API :String = DOMAIN_NAME + "/Apis/SearchApi/GetTags?" ;//user_type=Buyer&term=a
    //https://letusintroduceyou.com/Apis/SearchApi/GetTags?user_type=Buyer&term=a
    
    //Get Data By ID:
    static let SERVICE_PROVIDER :String = DOMAIN_NAME+"/Apis/ProfileApi/GetServiceProviderById" //service_provider_id
    static let PROPERTY_BY_ID : String = DOMAIN_NAME+"/Apis/ProfileApi/GetPropertyById" // property_id;
    static let SUPPLIER_BY_ID : String = DOMAIN_NAME+"/Apis/ProfileApi/GetSupplierById"
    
    static let UPLOAD_PROPERTY_IMAGE : String  = DOMAIN_NAME + "/Apis/Property/UploadImage"
    
    static let ADD_NEW_PROPERTY : String = DOMAIN_NAME+"/Apis/Property/AddProperty";
    
    
    
}
