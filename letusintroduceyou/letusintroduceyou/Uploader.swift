//
//  Uploader.swift
//  letusintroduceyou
//
//  Created by Admin on 24/08/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import UICircularProgressRing

class Uploader: NSObject {
    
    private static var inst : Uploader?;
    let manager = PHImageManager.default()
    
    let options = PHImageRequestOptions()
    
    
    static func getInst()-> Uploader{
        if inst == nil {
            inst = Uploader();
        }
        return inst!;
    }
    
    
    
    
    func uploadPropertyImage(property:Property , propImages : [PHAsset] , nPropImages : [PHAsset] , uPropImages : [PHAsset] , oPropImages : [PHAsset] ,progressClosure:@escaping (Progress)->Void , completed:@escaping ()->Void , error:@escaping ()->Void )
    {
        /*
         images =>              property_images[]
         Neighborhood Images => neighbor_images[]
         Utility Images =>      utility_images[]
         Ownership Images  =>   owner_images[]
         Property ID  =>        property_id
         */
        
        // Start Image Uploading Request
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                var count  = 0;
                //Add Property Images
                for pImage in propImages{
                    self.options.version = .original
                    self.options.isSynchronous = true
                    self.manager.requestImageData(for: pImage, options: self.options) { rawData, _, _, _ in
                        if let data = rawData {
                            if let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 0.4) {
                                multipartFormData.append(imageData, withName: "property_images[\(count)]", fileName: "pImageIOS\(count).jpg", mimeType: "image/jpeg")
                            }
                        }
                    }
                    count += 1;
                }
                count = 0;
                // Add Neighborhood Images
                for nImage in nPropImages{
                    self.options.version = .original
                    self.options.isSynchronous = true
                    self.manager.requestImageData(for: nImage, options: self.options) { rawData, _, _, _ in
                        if let data = rawData {
                            if let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 0.4) {
                                multipartFormData.append(imageData, withName: "neighbor_images[\(count)]", fileName: "nImageIOS\(count).jpg", mimeType: "image/jpeg")
                            }
                        }
                    }
                    count += 1;
                }
                count = 0;
                // Add Utility Images
                for uImage in uPropImages{
                    self.options.version = .original
                    self.options.isSynchronous = true
                    self.manager.requestImageData(for: uImage, options: self.options) { rawData, _, _, _ in
                        if let data = rawData {
                            if let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 0.4) {
                                multipartFormData.append(imageData, withName: "utility_images[\(count)]", fileName: "uImageIOS\(count).jpg", mimeType: "image/jpeg")
                            }
                        }
                    }
                    count += 1;
                }
                count = 0
                //Add Ownership Images //
                for oImage in oPropImages{
                    self.options.version = .original
                    self.options.isSynchronous = true
                    self.manager.requestImageData(for: oImage, options: self.options) { rawData, _, _, _ in
                        if let data = rawData {
                            if let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 0.4) {
                                multipartFormData.append(imageData, withName: "owner_images[\(count)]", fileName: "oImageIOS\(count).jpg", mimeType: "image/jpeg")
                            }
                        }
                    }
                    count += 1;
                }
                //--------------------------------
                // Add Property Id
                multipartFormData.append(property.id!.data(using: String.Encoding.utf8)!, withName: "property_id")
                print("Start Uploading...")
        },
            to: URLs.UPLOAD_PROPERTY_IMAGE,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { progress in
                        //print("Upload Progress : \(progress.fractionCompleted*100)")
                        //progressRing.setProgress(value: CGFloat(progress.fractionCompleted*100),animationDuration: 0.4);
                        progressClosure(progress);
                        
                    })
                    print(upload)
                    // Uploading Complete
                    upload.responseString(completionHandler: { res in
                            print("Upload Response String : \(res)")
                            //activity.isHidden = true
                        //blurEffectView.removeFromSuperview();
                        completed();
                    })
                case .failure(let encodingError):
                    print(encodingError)
                    error();
                }
         
        })
    }
    
    
}
