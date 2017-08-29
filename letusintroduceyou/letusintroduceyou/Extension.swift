//
//  Extension.swift
//  letusintroduceyou
//
//  Created by Admin on 01/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import Photos

/*
    Text Field
 */
extension UITextField {

    // Specially for login and Signup styling
    func setBottomBorder() {
        self.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func setBottomBorderDark() {
        self.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    @IBInspectable var placeHolderTextColor: UIColor? {
        set {
            let placeholderText = self.placeholder != nil ? self.placeholder! : ""
            attributedPlaceholder = NSAttributedString(string:placeholderText, attributes:[NSForegroundColorAttributeName: newValue!])
        }
        get{
            return self.placeHolderTextColor
        }
    }
    
    func containsAnyValue() -> Bool {
        if let a  = self.text{
            return !(a.isEmpty);
        }else{
            return false
        }
    }
    
    func addDoneButton(view:UIView) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar;
    }

}


extension String {
    //Email validaton
    var isEmailValid: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    // Need for UserTypes UI Text to Server Text Conversion
    func removeSpace() -> String {
        if self.contains(" "){
            return self.replacingOccurrences(of: " ", with: "");
        }
        return self;
    }
    
}



extension UIViewController {
    
    typealias Func = () -> Void
    // Quick Alert box with 2 Actions
    func showMessage(title:String , message:String ,doneButtonText:String?,cancelButtonText:String? , done:Func? , cancel : Func?) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let textDone =  doneButtonText {
            alert.addAction(UIAlertAction(title: textDone, style: UIAlertActionStyle.default, handler: { action in
                if let fun = done{
                    fun();
                }
            }))
        }
        
        if let textCancel = cancelButtonText{
            alert.addAction(UIAlertAction(title: textCancel, style: UIAlertActionStyle.cancel, handler: {action in
                if let fun = cancel{
                    fun();
                }
            }))
        }
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // Specially used in User Profile 
    // because there is no done or submit button on the keyboard of numerical type
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlertSheetWith(actions : [UIAlertAction] , title:String , message:String)  {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        for action in actions{
            sheet.addAction(action);
        }
        self.present(sheet, animated: true, completion: nil)
    }
    
}



extension UIImageView {
    // Quick shadow for imageView
    func applyListingShadow()  {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2
    }
    
    /// Loading indicator for SDWebImage
    func showLoadingSd()  {
        self.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
        self.setShowActivityIndicator(true)
    }
    
    
    func loadAsset(asset: PHAsset)  {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activity.color = UIColor.gray
        activity.frame = self.bounds
        self.addSubview(activity)
        activity.startAnimating()
        print("Start Loading Image")
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        manager.requestImage(for: asset, targetSize: CGSize(width: 50.0, height: 50.0), contentMode: .default, options: option, resultHandler: {(result, info)->Void in
            self.image = result ?? UIImage();
            print("Loaded Image Successfully")
            activity.removeFromSuperview()
        })
    }
    /*
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 50.0, height: 50.0), contentMode: .default, options: option, resultHandler: {(result, info)->Void in
            //            print("Image Returned \(result)")
            thumbnail = result ?? UIImage();
        })
        return thumbnail
    }
    */
}



extension UILabel{
    // Attributed text for Bold and Regular text in one UILabel Ref Stackoverflow
    func setBoldAndRegularTitle(boldString:String , regularString : String , boldFontSize:Int , regularFontSize:Int) {
        //Code sets label (yourLabel)'s text to "Tap and hold(BOLD) button to start recording."
        let boldAttribute = [
            //You can add as many attributes as you want here.
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: CGFloat(boldFontSize))!]//14
        
        let regularAttribute = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(regularFontSize))!]//12
        
        let boldAttributedString = NSAttributedString(string:  boldString, attributes: boldAttribute)
        let endAttributedString = NSAttributedString(string: regularString, attributes: regularAttribute )
        let fullString =  NSMutableAttributedString()
        
        fullString.append(boldAttributedString)
        fullString.append(endAttributedString)
        
        self.attributedText = fullString
    }
}


extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y-200,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    //Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    //Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}
