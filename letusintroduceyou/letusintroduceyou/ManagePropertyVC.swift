//
//  ManagePropertyVC.swift
//  letusintroduceyou
//
//  Created by Admin on 03/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Floaty

class ManagePropertyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addPropertyButton();
        
        
     
    }
    
    
    
    
    func addPropertyButton()  {
        let floaty = Floaty()
        floaty.buttonColor =  UIColor(red: 25/255, green: 193/255, blue: 208/255, alpha: 1);
        floaty.addItem("Add Property", icon: UIImage(named: "property")!, handler: { item in
            print("Clicked: \(item)")
            //Open AddPropertyVC
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPropertyVC") as! AddPropertyVC;
            self.navigationController?.pushViewController(vc, animated: true);
            //------------------
            floaty.close();
        });
        floaty.itemButtonColor = UIColor(red: 25/255, green: 193/255, blue: 208/255, alpha: 1);
        self.view.addSubview(floaty)
    }

    
}
