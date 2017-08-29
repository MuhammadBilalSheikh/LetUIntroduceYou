//
//  CoreData.swift
//  letusintroduceyou
//
//  Created by Admin on 15/08/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

class CoreData: NSObject {
    
    private static var instance : CoreData?;
    private var appDelegate : AppDelegate?;
    private var managedContext : NSManagedObjectContext?;
    
    public static func getInst() -> CoreData {
        if instance == nil{
            instance = CoreData();
        }
        return instance!;
    }
    
    private override init() {
        super.init()
        appDelegate = UIApplication.shared.delegate as? AppDelegate;
        managedContext = appDelegate!.persistentContainer.viewContext;
    }
    
    //Get All Queries For Search View Controller
    func getAllSearchQueries()  -> [String] {
        var arr = [String]();
        do {
            //Context - Fetch Request
            let searchRequest = try managedContext!.fetch(NSFetchRequest<NSManagedObject>(entityName:"SearchQuery"));
            //Reverse Data Added in List
            for item in searchRequest {
                arr.append(item.value(forKeyPath: "name") as! String);
            }
            //            if(arr.count > 10){
            //                arr = arr[0..<10]; // Limit Results to 10 only
            //            }
            
            arr.reverse();
            return arr;
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return arr;
        }
        
    }
    
    // Save Query For Search View Controller
    func saveSearchQuery(query: String) -> Bool{
        // Context -  Insert Data Managed Context;
        let entity = NSEntityDescription.entity(forEntityName: "SearchQuery",in: managedContext!)!;
        let search = NSManagedObject(entity: entity, insertInto: managedContext);
        //insert Data
        search.setValue(query, forKeyPath: "name")
        
        do {
            try managedContext?.save()
            //people.append(person)
            return true;
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false;
        }
    }
    
    
    
    func saveUser(user : AppUser) {
        let userData = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "UserData",in: managedContext!)!, insertInto: managedContext);
        //insert Data
        userData.setValue(user.city ?? "N/A", forKeyPath: "city");
        userData.setValue(user.country ?? "N/A", forKeyPath: "country");
        userData.setValue(user.currentUserType ?? "" , forKeyPath: "current_type");
        userData.setValue(user.email ?? "N/A", forKeyPath: "email");
        userData.setValue(user.firstName ?? "N/A", forKeyPath: "first_name");
        userData.setValue(user.lastName ?? "N/A", forKeyPath: "last_name");
        userData.setValue(user.latitude ?? 0.0, forKeyPath: "lat");
        userData.setValue(user.longitude ?? 0.0, forKeyPath: "lng");
        userData.setValue(user.mobile ?? "N/A", forKeyPath: "mobile");
        userData.setValue(user.phone ?? "N/A", forKeyPath: "phone");
        userData.setValue(user.userId ?? "N/A", forKeyPath: "user_id");
        userData.setValue(user.imageUrl ?? "N/A", forKeyPath: "image_url");
        
        
        do {
            try managedContext?.save()
            
            for type in user.userType!{
                let userType = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "UserType",in: managedContext!)!, insertInto: managedContext);
                userType.setValue(type.key, forKeyPath: "type");
                userType.setValue(type.value,forKeyPath: "availability");
                try managedContext?.save();
                print("Saved Data \(type)")
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func setUserCurrentType(set:Bool , type:String) {
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "UserData", in: managedContext!)
        // Initialize Batch Update Request
        let batchUpdateRequest = NSBatchUpdateRequest(entity: entityDescription!)
        // Configure Batch Update Request
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        batchUpdateRequest.propertiesToUpdate = ["current_type": set ? type : "" ]
        do {
            // Execute Batch Request
            try managedContext?.execute(batchUpdateRequest)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getCurrentUser(appUser:AppUser) -> Bool {
        ///let appUser = AppUser.getInst();
        do {
            //Context - Fetch Request
            let request = try managedContext!.fetch(NSFetchRequest<NSManagedObject>(entityName:"UserData"));
            if request.count > 0 {
                print("Request Count is true")
            }else{
                return false;
            }
            let userRequest = request.first;
            let userTypes = try managedContext!.fetch(NSFetchRequest<NSManagedObject>(entityName: "UserType"));
            
            appUser.userId = userRequest?.value(forKeyPath: "user_id") as? String;
            appUser.email = userRequest?.value(forKeyPath: "email") as? String;
            appUser.firstName = userRequest?.value(forKeyPath: "first_name") as? String;
            appUser.lastName = userRequest?.value(forKeyPath:"last_name") as? String;
            appUser.imageUrl = userRequest?.value(forKeyPath: "image_url") as? String;
            appUser.latitude = userRequest?.value(forKeyPath: "lat") as? Double;
            appUser.longitude = userRequest?.value(forKeyPath: "lng") as? Double;
            appUser.city = userRequest?.value(forKeyPath: "city") as? String;
            appUser.country = userRequest?.value(forKeyPath: "country") as? String;
            appUser.phone = userRequest?.value(forKeyPath: "phone") as? String;
            appUser.mobile = userRequest?.value(forKeyPath: "mobile") as? String;
            appUser.currentUserType = userRequest?.value(forKeyPath: "current_type") as? String;
            if let t = appUser.currentUserType {
                if(t.characters.count < 2){
                    print("Type of User is Reset \(t)")
                    appUser.currentUserType = nil
                }
            }
            
            appUser.userType = [String:Bool]();
            for obj in userTypes {
                //  if (obj.string?.contains("er"))! {
                appUser.userType?[(obj.value(forKeyPath: "type") as? String)!] = obj.value(forKeyPath: "availability") as? Bool;
                //}
            }
            
            return true;
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false;
        }
        
    }
    
    
    func logoutUser()  {
        let fetchUserData = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let requestUD = NSBatchDeleteRequest(fetchRequest: fetchUserData);
        let fetchUserType = NSFetchRequest<NSFetchRequestResult>(entityName: "UserType")
        let requestUT = NSBatchDeleteRequest(fetchRequest: fetchUserType);
        let fetchSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchQuery")
        let requestSR = NSBatchDeleteRequest(fetchRequest: fetchSearch);
        
        do{
            try managedContext?.execute(requestUD)
            try managedContext?.execute(requestUT)
            try managedContext?.execute(requestSR)
        }catch let err as NSError{
            print("Error While Logout user :\(err)")
        }
    }
    
    
    
    
    
}
