//
//  MyTabBarController.swift
//  letusintroduceyou
//
//  Created by Admin on 05/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    let images = ["home",//0
                  "search",//1
                  "profile",//2
                  "nearby",//3
                  "company",//4
                  "dashboard",//5
                  "forum",//6
                  "listing",//7
                  "property",//8 -- Property -> Image Should be changed
                   "service_provider",//9
                   "supplier",//10
                   "my_cutomers"//11 /
    ];

    let controllers = ["HomeNavigation",//0
                "SearchNavigation",//1
                "ProfileNavigation",//2
                "NearByNavigation",//3
                "CompanyNavigation",//4
                "DashboardNavigation",//5
                "ForumNavigation",//6
                "ListingNavigation",//7
                "PropertyNavigation",//8
                "ServiceProviderNavigation",//9
                "SupplierNavigation",//10
                "MyCutomersNavigation"//11
    ];
    
    let names = [
                        "Home",//0
                        "Search",//1
                        "Profile",//2
                        "Nearby",//3
                        "Company",//4
                        "Dashboard",//5
                        "Forum",//6
                        "Listing",//7
                        "Property",//8
                        "Service Provider",//9
                        "Supplier",//10
                        "My Cutomers"//11
    ];
    enum View : Int{
        case Home,//0
        Search,//1
        Profile,//2
        Nearby,//3
        Company,//4
        Dashboard,//5
        Forum,//6
        Listing,//7
        Property,//8
        ServiceProvider,//9
        Supplier,//10
        MyCutomers//11
    }

    var userType : String?;
    
    override func viewDidLoad() {
        if let uType = Constants.UserType(rawValue: userType!){
        switch uType {
            case .Agent:
                viewControllers = [
                    getNav(index: View.Dashboard),
                    getNav(index: View.Search),
                    getNav(index: View.Property),
                    getNav(index: View.Listing),
                    getNav(index: View.Profile),
                    //getNav(index: View.Company),
                    getNav(index: View.ServiceProvider),
                    getNav(index: View.Forum)
                ];
            case .GeneralUser:
                viewControllers = [
                    getNav(index: View.Home),
                    getNav(index: View.Profile),
                    getNav(index: View.Search),
                    getNav(index: View.Nearby),
                    getNav(index: View.ServiceProvider),
                    getNav(index: View.Forum)
                ]
            case .ServiceProvider:
                viewControllers = [
                    getNav(index: View.Home),
                    getNav(index: View.Profile),
                    getNav(index: View.Search),
                    getNav(index: View.Supplier),
                    getNav(index: View.MyCutomers)
                ]
            case .Supplier:
                viewControllers = [
                    getNav(index: View.Dashboard),
                    getNav(index: View.Profile),
                    getNav(index: View.Search),
                    getNav(index: View.ServiceProvider),
                    getNav(index: View.MyCutomers)
                ]
            case .Buyer:
                viewControllers = [
                    getNav(index: View.Home),
                    getNav(index: View.Profile),
                    getNav(index: View.Listing),
                    getNav(index: View.Property),
                    //getNav(index: View.Company),
                    getNav(index: View.ServiceProvider),
                    getNav(index: View.Forum)
                ]
            }
        }
        self.tabBar.tintColor = UIColor.init(red: 25/255, green: 193/255, blue: 208/255, alpha: 1)

    }
    
    
    func getNav(index:View) -> UIViewController {
        let navigation = self.storyboard?.instantiateViewController(withIdentifier: self.controllers[index.rawValue]);
        navigation?.title = self.names[index.rawValue];
        navigation?.tabBarItem.image = UIImage(named: self.images[index.rawValue]);
        return navigation!;
    }
    
    
    
    
}
