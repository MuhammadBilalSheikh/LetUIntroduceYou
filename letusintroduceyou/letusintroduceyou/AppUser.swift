//
//  AppUser.swift
//  letusintroduceyou
//
//  Created by Admin on 22/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppUser: NSObject {
    private static var instance:AppUser?;
    
    private override init() {
        super.init();
    }
    
    static func getInst() -> AppUser {
        if(AppUser.instance == nil){
            AppUser.instance = AppUser();
            AppUser.instance?.isLoggedIn = CoreData.getInst().getCurrentUser(appUser: AppUser.instance!);
        }
        return AppUser.instance!;
    }
    var isLoggedIn:Bool?;
    var userId:String?;
    var firstName:String?;
    var lastName:String?;
    var email:String?;
    var userType:[String:Bool]?;
    var imageUrl:String?;
    var latitude:Double?;
    var longitude:Double?;
    var currentUserType:String?;
    var city:String?;
    var country:String?;
    var mobile:String?;
    var phone:String?;
    
    public func setUser(user:JSON){
        self.userId = user["user_id"].string;
        self.email = user["email"].string;
        self.firstName = user["first_name"].string;
        self.lastName = user["last_name"].string;
        self.imageUrl = user["image"].string;
        self.latitude = user["lat"].double ?? 0;
        self.longitude = user["lng"].double ?? 0;
        self.city = user["city"].string ?? "N/A";
        self.country = user["country"].string ?? "N/A";
        self.phone = user["phone"].string ?? "N/A";
        self.mobile = user["mobile"].string ?? "N/A";
        
        let arr = user["user_type"].array;
        self.userType = [String:Bool]();
        for obj in arr! {
          //  if (obj.string?.contains("er"))! {
                self.userType?[obj.string!] = true;
            //}
        }
        CoreData.getInst().saveUser(user: self);
        self.isLoggedIn = true;
    }
    
    public func hasType(apiType:String)-> Bool{
        return userType![apiType] ?? false;
    }
    
    public func logout(){
        self.userId = nil;
        self.email = nil;
        self.firstName = nil;
        self.lastName = nil;
        self.imageUrl = nil;
        self.latitude = nil;
        self.longitude = nil;
        self.userType = nil;
        self.currentUserType = nil;
        self.city = nil;
        self.country = nil;
        self.mobile = nil;
        self.phone = nil;
        self.isLoggedIn = false;
        CoreData.getInst().logoutUser();
        AppUser.instance = nil
    }
    public func setDummyUser(){
        self.userId = "123";
        self.email = "moosa.bh@gmail.com";
        self.firstName = "Moosa";
        self.lastName = "Baloch";
        self.imageUrl = "http://alisonstech.com";
        self.latitude =  0;
        self.longitude =  0;
        self.city =  "N/A";
        self.country =  "N/A";
        self.phone =  "N/A";
        self.mobile =  "N/A";
        
        let arr = Constants.USER_TYPE;
        
        self.userType = [String:Bool]();
        for obj in arr {
            //  if (obj.string?.contains("er"))! {
            self.userType?[obj] = true;
            //}
        }
    }
    func setUserType(set:Bool , val:String)  {
        self.currentUserType = set ? val : nil;
        CoreData.getInst().setUserCurrentType(set: set, type: val);
    }
    
    
}
