//
//  UserTypeVC.swift
//  letusintroduceyou
//
//  Created by Admin on 02/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class UserTypeVC: UIViewController , UITableViewDelegate , UITableViewDataSource{
    let user = AppUser.getInst();
    
    @IBOutlet weak var userTypeTableView: UITableView!
    var arr = [String]();
    override func viewDidLoad() {
        userTypeTableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        arr = Constants.USER_TYPE;//NON_UI_TEXT
        userTypeTableView.reloadData();
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if user.hasType(apiType: arr[indexPath.row]){
            user.setUserType(set: true, val: arr[indexPath.row])
            let tabController = storyboard?.instantiateViewController(withIdentifier: "MyTabBarController") as! MyTabBarController;
            tabController.userType = arr[indexPath.row];
            self.present(tabController, animated: true, completion: nil)
        }else{
            self.showMessage(title: "Pending", message: "Work in progress", doneButtonText: "Ok", cancelButtonText: nil, done: nil, cancel: nil);
        }
    }
    
    @IBAction func logoutOnClick(_ sender: Any) {
        AppUser.getInst().logout();
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC");
        if let window = UIApplication.shared.keyWindow{
            window.rootViewController = loginVC;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTypeCell") as! UserTypeCell;
        cell.typeLabel.text = Constants.USER_TYPE_SRV2UI[arr[indexPath.row]];
        cell.typeLabel.textColor = user.hasType(apiType: arr[indexPath.row]) ? UIColor.white : UIColor.lightGray;
        
        cell.layer.backgroundColor = UIColor.clear.cgColor;
        cell.backgroundColor = UIColor.clear;
        return cell;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    
}

