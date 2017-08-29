//
//  ProfileVC.swift
//  letusintroduceyou
//
//  Created by Admin on 07/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var labelUserType: UILabel!
    @IBOutlet weak var editLastName: UITextField!
    @IBOutlet weak var editFirstName: UITextField!
    @IBOutlet weak var labelUserEmail: UILabel!
    @IBOutlet weak var labelUserPhone: UILabel!
    @IBOutlet weak var labelUserMobile: UILabel!
    @IBOutlet weak var labelUserCity: UILabel!
    @IBOutlet weak var labelUserCountry: UILabel!
    @IBOutlet weak var labelUserNameFL: UILabel!
    @IBOutlet weak var editUserMobile: UITextField!
    
    @IBOutlet weak var editUserCountry: UITextField!
    @IBOutlet weak var editUserCity: UITextField!
    @IBOutlet var mainScrollView: UIView!
    @IBOutlet weak var buttonSave_ChangeType: UIButton!
    @IBOutlet weak var buttonCancel_UpdateProfile: UIButton!
    @IBOutlet weak var editUserPhone: UITextField!
    override func viewDidLoad() {
        self.navigationItem.title = "Profile"
        let logoutBar: UIBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutOnClick) )
        self.hideKeyboardWhenTappedAround();
        self.navigationItem.rightBarButtonItem = logoutBar ;
        editLastName.delegate = self;
        editFirstName.delegate = self;
        editUserPhone.delegate = self;
        editUserMobile.delegate = self;
        editUserCountry.delegate = self;
        editUserCity.delegate = self;
    }
    var user : AppUser?;//
    override func viewDidAppear(_ animated: Bool) {
        user = AppUser.getInst();
        labelUserNameFL.text = "\(String(describing: user!.firstName!)) \(String(describing: user!.lastName!))"
        labelUserCity.text = user!.city;
        labelUserCountry.text = user!.country;
        labelUserType.text = Constants.USER_TYPE_SRV2UI[(user!.currentUserType!)];
        labelUserEmail.text = user!.email;
        labelUserPhone.text = user!.phone;
        labelUserMobile.text = user!.mobile;
        setEditableMode(enabled: false, save: false);
        
    }
    
    @IBAction func changeTypeOnClick(_ sender: Any) {
        if(profileIsInEditMode){
            saveProfileUpdate();
        }else{
            user?.setUserType(set: false,val: "");
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeVC");
            if let window = UIApplication.shared.keyWindow{
                window.rootViewController = loginVC;
            }
        }
    }
    
    
    @IBAction func updateProfileOnClick(_ sender: Any) {
        if(profileIsInEditMode){
            print("Canceled")
            setEditableMode(enabled: false ,save: false);
        }else{
            let  alert : UIAlertController = UIAlertController(title: "Update Profile", message: "Select any one option to continue", preferredStyle: UIAlertControllerStyle.actionSheet)
            let action1 = UIAlertAction(title: "Update User Data" , style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                self.setEditableMode(enabled: true, save: true)
            })
            let action2 = UIAlertAction(title: "Change Profile Image" , style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                
                
            })
            let action3 = UIAlertAction(title: "Change Password" , style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                
            })
            let actionC = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
            
            
            alert.addAction(action1);
            alert.addAction(action2);
            alert.addAction(action3);
            alert.addAction(actionC);
            
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    func logoutOnClick(_ sender: Any) {
        AppUser.getInst().logout();
        if let story = self.storyboard {
            let loginVC = story.instantiateViewController(withIdentifier: "LoginVC")
            if let window = UIApplication.shared.keyWindow{
                window.rootViewController = loginVC;
            }
        }
    }
    var profileIsInEditMode : Bool = false;
    func setEditableMode(enabled:Bool , save : Bool){
        profileIsInEditMode = enabled;
        if(enabled){
            buttonSave_ChangeType.setTitle("Save" , for: UIControlState.normal);
            buttonCancel_UpdateProfile.setTitle("Cancel", for: UIControlState.normal);
            editUserMobile.text = labelUserMobile.text;
            editUserPhone.text = labelUserPhone.text;
            editFirstName.text = user!.firstName!
            editLastName.text = user!.lastName!
            editUserCountry.text = labelUserCountry.text;
            editUserCity.text = labelUserCity.text;
        }else{
            buttonSave_ChangeType.setTitle("Change User Type" , for: UIControlState.normal);
            buttonCancel_UpdateProfile.setTitle("Update Profile", for: UIControlState.normal);
            if save {
                labelUserMobile.text = editUserMobile.text!
                labelUserNameFL.text = "\(editFirstName.text!) \(editLastName.text!)"
                labelUserPhone.text = editUserPhone.text!
                labelUserCity.text = editUserCity.text!
                labelUserCountry.text = editUserCountry.text!
            }
        }
        labelUserMobile.isHidden = enabled;
        labelUserPhone.isHidden = enabled;
        labelUserNameFL.isHidden = enabled;
        labelUserCity.isHidden = enabled;
        labelUserCountry.isHidden = enabled;
        editUserPhone.isHidden = !enabled;
        editLastName.isHidden = !enabled;
        editFirstName.isHidden = !enabled;
        editUserMobile.isHidden = !enabled;
        editUserCity.isHidden = !enabled;
        editUserCountry.isHidden = !enabled;
        
    }
    
    func saveProfileUpdate() {
        let firstName = editFirstName.text!;
        let lastName = editLastName.text!;
        let mobile = (editUserMobile.text!.characters.count>2) ? editUserMobile.text! : "Not Available";
        let phone = (editUserPhone.text!.characters.count>2) ? editUserPhone.text! : "Not Available";
        let city = editUserCity.text!;
        let country = editUserCountry.text!;
        
        if firstName.characters.count > 2 {
            if lastName.characters.count > 2 {
                if city.characters.count > 2 {
                    if country.characters.count > 2 {
                        
                        self.networkRequest(first: firstName, last: lastName, mob: mobile, phone: phone, city: city, country: country, user_id: user!.userId!)
                    }else{
                        showEditError(field: "country name.", tf: editUserCountry)
                    }
                }else{
                    showEditError(field: "city name.", tf: editUserCity)
                }
            }else{
                showEditError(field: "last name.", tf: editLastName)
            }
        }else{
            showEditError(field: "first name.", tf: editFirstName)
        }
        
    }
    private func showEditError(field:String , tf:UITextField){
        showMessage(title: "Invalid Field", message: "Please enter a valid "+field, doneButtonText: "Ok", cancelButtonText: nil, done: {
            tf.becomeFirstResponder();
        }, cancel: nil);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // if (textField.layer.position.y > 250) {
        //mainScrollView.setContentOffset(CGPoint(x: 0, y: (textField.layer.position.y - 250)), animated: true);
        let points = (textField.layer.position.y - 210);
        self.view.frame.origin.y = points
        //}
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //mainScrollView.setContentOffset(CGPoint(x:0,y:0), animated: true);
        self.view.frame.origin.y = 0;
    }
    
    func networkRequest(first:String , last:String , mob:String , phone : String , city:String , country : String , user_id:String)  {
        let parameters : Parameters = [
            "first": first ,
            "last":last,
            "city":city,
            "country":country,
            "mobile":mob,
            "phone":phone,
            "user_id":user_id,
            "mob":"true"
        ];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        Alamofire.request(URLs.UPDATE_PROFILE,method: .post, parameters: parameters).responseString { res in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            switch res.result {
            case .success(let rawData):
                print(rawData);
                self.setEditableMode(enabled: false, save: true);
                self.user!.city = city;
                self.user!.country = country;
                self.user!.firstName = first;
                self.user!.lastName = last;
                self.user!.phone = phone;
                self.user!.mobile = mob;
                break;
            case .failure:
                //   print("Error (Alamofire)")
                self.showMessage(title: "Network Error", message: "Network error while saving profile data, please try again later.", doneButtonText: "Ok", cancelButtonText: nil, done: {
                    
                }, cancel: nil);
                self.setEditableMode(enabled: false, save: false);
                break;
            }
        }
    }
    
}
