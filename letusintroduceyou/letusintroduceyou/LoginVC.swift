//
//  LoginVC.swift
//  letusintroduceyou
//
//  Created by Admin on 01/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController , UITextFieldDelegate  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        //setUITextFieldStyle();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setUITextFieldStyle();
        //self.view.addSubview(autocompleteTableView)
    }
    override func viewDidAppear(_ animated: Bool) {
        print("Login Screen")
        setUITextFieldStyle()
        emailTextField.text = "daniyal@gmail.com";
        passwordTextField.text = "123"
        //-------------------------------------------------------------------
     /*
        let email = emailTextField.text //// ? is repersenting optional Value
        
        //App may crash if value is nil
        //First way to unwrap optional
        print(email!)
        
        //App print No Email if value is nil
        //Second way to unwrap optional with default Value
        print(email ?? "No Email")
        
        // App print N/A if value is nil
        //Third way to unwrap optional value in if Condition
        if let e = email {
            print(e)// prints email
        }else{
            print("N/A")
        }
 */      
 //-------------------------------------------------------------------
    }
    
    func setUITextFieldStyle()  {
        emailTextField.delegate = self;
        passwordTextField.delegate = self;
        passwordTextField.setBottomBorder();
        emailTextField.setBottomBorder();
        emailTextField.placeHolderTextColor = UIColor.white
        passwordTextField.placeHolderTextColor = UIColor.white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.continue) {
            passwordTextField.becomeFirstResponder();
            return true;
        }else{
            textField.resignFirstResponder()
            //self.onLoginClick(self)
            return true;
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.layer.position.y > 250) {
            let yPosition = textField.layer.position.y - 250;
            let point = CGPoint(x: 0, y: yPosition);
            scrollView.setContentOffset( point, animated: true);
        };
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true);
    }
    
    
    
    @IBAction func onForgotPassClick(_ sender: Any) {
        print("Forgot Pass");
    }
    
    @IBAction func onSignUpClick(_ sender: Any) {
        print("signUP")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC;
        self.present(vc, animated: true, completion: nil);
        
    }
    @IBAction func onLoginClick(_ sender: Any) {
        passwordTextField.resignFirstResponder();
        let email = String(describing: emailTextField.text!);
        let pass = String(describing: passwordTextField.text!);
        if email.isEmailValid {
            if !pass.isEmpty{
                        let parameters : Parameters = ["LoginForm[password]": pass , "LoginForm[username]":email,"mob":"true"];
                self.showNetwork(show: true);
                        Alamofire.request(URLs.LOGIN,method: .post, parameters: parameters).responseString { res in
                            switch res.result {
                                case .success(let rawData):
                                    self.showNetwork(show: false);
                                    if let data = rawData.data(using: .utf8, allowLossyConversion: false) {
                                    let json = JSON(data);
                                    let user = json["user"];
                                   // print("User Login Data is : \(user) -> JSON : \(json) -> Email:\(email)|Pass:\(pass)")
                                    if user != JSON.null {
                                        print("\(user) (Alamofire)");
                                        AppUser.getInst().setUser(user: user);
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeVC") as! UserTypeVC;
                                        self.present(vc, animated: true, completion: nil);
                                    }else{
                                        print(rawData)
                                        self.showMessage(title: "Login Failed", message: "Incorrect email/password combinations.", doneButtonText: "Ok", cancelButtonText: nil, done: {
                                            self.emailTextField.becomeFirstResponder();
                                           // self.passwordTextField.text = "";
                                        }, cancel: nil);
                                    }
                                    }
                                    break;
                                case .failure:
                                 //   print("Error (Alamofire)")
                                    self.showNetwork(show: false);
                                    self.showMessage(title: "Login Failed", message: "Network error please try again later.", doneButtonText: "Ok", cancelButtonText: nil, done: {
                                        print("Error")
                                        ////////////////// Dummy Login START///////////////////////
                                        if Constants.isDummyMode{
                                            AppUser.getInst().setDummyUser()
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeVC") as! UserTypeVC;
                                            self.present(vc, animated: true, completion: nil);
                                        }
                                        ////////////////// Dummy Login END///////////////////////
                                    }, cancel: nil);
                                    
                                    break;
                            }
                        }
            }else{
                showMessage(title: "Invalid", message: "Insert a valid password please", doneButtonText: "Ok", cancelButtonText: nil, done: {
                    self.passwordTextField.becomeFirstResponder();
                }, cancel: nil);
            }
        }else{
            showMessage(title: "Invalid Email", message: "Insert a valid email address please", doneButtonText: nil, cancelButtonText: "Ok", done:nil,cancel:{
                self.emailTextField.becomeFirstResponder();
            });
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    func showNetwork(show:Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show;
    }
  
}
