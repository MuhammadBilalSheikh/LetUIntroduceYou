//
//  SignupVC.swift
//  letusintroduceyou
//
//  Created by Admin on 01/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignupVC: UIViewController , UITextFieldDelegate{
  
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        setTextFieldAttribs()
    }
    /*
     keys => values
     mob =>true
     usertype
     firstname
     lastname
     email
     password
     retype
     
     in success response
     {
     "user": {
     "user_id": "b49313113770134c54ccc0945b",
     "first_name": "umer",
     "last_name": "umer",
     "email": "umer1412f@aptechsite.nett",
     "user_type": [
     "Buyer",
     "ServiceProvider"
     ]
     }
     }
     
     not success response
     signup_fail Email in use this usertype
     */
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.setTextFieldAttribs();
      //  self.networkRequest();
    }
    
    func networkRequest(first:String , last:String , type:String , email:String , pass:String )  {
        let parameters : Parameters = [
            "firstname": first ,
            "lastname":last,
            "usertype":type,
            "email":email,
            "password":pass,
            "retype":pass,
            "mob":"true"
        ];
        self.showNetwork(show: true);
        Alamofire.request(URLs.SIGN_UP,method: .post, parameters: parameters).responseString { res in
            switch res.result {
            case .success(let rawData):
                self.showNetwork(show: false);
                if let data = rawData.data(using: .utf8, allowLossyConversion: false) {
                    let json = JSON(data);
                    let user = json["user"];
                    if user != JSON.null {
                        print("\(user) (Alamofire)");
                        //AppUser.getInst().setUser(user: user);
                        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeVC") as! UserTypeVC;
                        //self.present(vc, animated: true, completion: nil);
                        self.showMessage(title: "Sign Up succeeded", message: "Your account is created successfully.", doneButtonText: "Ok", cancelButtonText: nil, done: {
                            self.dismiss(animated: true, completion: nil);
                        }, cancel: nil);
                    }else{
                        self.showMessage(title: "Sign Up Failed", message: rawData, doneButtonText: "Ok", cancelButtonText: nil, done: {
                            self.emailTextField.becomeFirstResponder();
                            self.passwordTextField.text = "";
                        }, cancel: nil);
                    }
                }
                break;
            case .failure:
                //   print("Error (Alamofire)")
                self.showNetwork(show: false);
                self.showMessage(title: "Login Failed", message: "Network error please try again later.", doneButtonText: "Ok", cancelButtonText: nil, done: {
                   
                }, cancel: nil);
                
                break;
            }
        }
    }
    
    
    
    
    func setTextFieldAttribs() {
        firstNameTextField.delegate = self;
        lastNameTextField.delegate = self;
        emailTextField.delegate = self;
        passwordTextField.delegate = self;
        confirmPassTextField.delegate = self;
        
        firstNameTextField.setBottomBorder()
        lastNameTextField.setBottomBorder()
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        confirmPassTextField.setBottomBorder()

        firstNameTextField.placeHolderTextColor = UIColor.white
        lastNameTextField.placeHolderTextColor = UIColor.white
        emailTextField.placeHolderTextColor = UIColor.white
        passwordTextField.placeHolderTextColor = UIColor.white
        confirmPassTextField.placeHolderTextColor = UIColor.white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.continue) {
            if textField == firstNameTextField {
                lastNameTextField.becomeFirstResponder();
            }else if textField == lastNameTextField{
                emailTextField.becomeFirstResponder();
            }else if textField == emailTextField{
                passwordTextField.becomeFirstResponder();
            }else if textField == passwordTextField{
                confirmPassTextField.becomeFirstResponder();
            }
            return true;
        }else{
            textField.resignFirstResponder()
            return true;
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.layer.position.y > 250) {
            scrollView.setContentOffset(CGPoint(x: 0, y: (textField.layer.position.y - 250)), animated: true);
        };
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true);
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func signUpOnClick(_ sender: Any) {
        let firstName = firstNameTextField.text! ;
        let lastName = lastNameTextField.text!;
        let email = emailTextField.text!;
        let password = passwordTextField.text!;
        let cPassword = confirmPassTextField.text!;
        
        if email.isEmailValid {
            if !firstName.isEmpty {
                if !lastName.isEmpty {
                    if ((!password.isEmpty && !cPassword.isEmpty)&&(password == cPassword)) {
                        let arr = Constants.USER_TYPE;//till 4
                        let  alert : UIAlertController = UIAlertController(title: "User Type", message: "Select any one user type to signup", preferredStyle: UIAlertControllerStyle.actionSheet)
                        let action1 = UIAlertAction(title: Constants.USER_TYPE_SRV2UI[arr[0]] , style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                        self.networkRequest(first: firstName, last: lastName, type: arr[0], email: email, pass: password)
                        })
                        let action2 = UIAlertAction(title: Constants.USER_TYPE_SRV2UI[arr[1]] , style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                            self.networkRequest(first: firstName, last: lastName, type: arr[1], email: email, pass: password)
                        })
                        let action3 = UIAlertAction(title: Constants.USER_TYPE_SRV2UI[arr[2]] , style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                            self.networkRequest(first: firstName, last: lastName, type: arr[2], email: email, pass: password)
                        })
                        let action4 = UIAlertAction(title: Constants.USER_TYPE_SRV2UI[arr[3]] , style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                            self.networkRequest(first: firstName, last: lastName, type: arr[3], email: email, pass: password)
                        })
                        let action5 = UIAlertAction(title: Constants.USER_TYPE_SRV2UI[arr[4]] , style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                            self.networkRequest(first: firstName, last: lastName, type: arr[4], email: email, pass: password)
                        })
                        let action6 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
                        
                        alert.addAction(action1);
                        alert.addAction(action2);
                        alert.addAction(action3);
                        alert.addAction(action4);
                        alert.addAction(action5);
                        alert.addAction(action6);

                        self.present(alert, animated: true, completion: nil);
                        
                        
                    }else{
                        self.showMessage(title: "Invalid password", message: "Password mismatched or invalid", doneButtonText: "Okey", cancelButtonText: nil, done: {
                            self.passwordTextField.becomeFirstResponder();
                        }, cancel: nil);
                    }
                }else{
                    self.showMessage(title: "Invalid Field", message: "Please insert a valid last name", doneButtonText: "Okey", cancelButtonText: nil, done: {
                        self.lastNameTextField.becomeFirstResponder();
                    }, cancel: nil)
                }
            }else{
                self.showMessage(title: "Invalid Field", message: "Please insert a valid first name", doneButtonText: "Okey", cancelButtonText: nil, done: {
                    self.firstNameTextField.becomeFirstResponder();
                }, cancel: nil);
            }
        }else{
            self.showMessage(title: "Invalid Email", message: "Please insert a valid email address", doneButtonText: "Okey", cancelButtonText: nil, done: {
                self.emailTextField.becomeFirstResponder();
            }, cancel: nil);
        }
    }
    
    @IBAction func backOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    func showNetwork(show:Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show;
    }
    
}
