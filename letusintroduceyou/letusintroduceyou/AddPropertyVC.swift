//
//  AddPropertyVC.swift
//  letusintroduceyou
//
//  Created by Admin on 21/08/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import DropDown
import JVFloatLabeledTextField
import BSImagePicker
import Photos
import Alamofire
import SwiftyJSON
import UICircularProgressRing


class AddPropertyVC: UIViewController , UITextFieldDelegate , UICollectionViewDelegate , UICollectionViewDataSource{
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var nImagesCollectionView: UICollectionView!
    @IBOutlet weak var uImagesCollectionView: UICollectionView!
    @IBOutlet weak var oImagesCollectionView: UICollectionView!
    @IBOutlet weak var maidRoomsTextField: JVFloatLabeledTextField!
    @IBOutlet weak var imagesButton: UIButton!
    @IBOutlet weak var nImagesButton: UIButton!
    @IBOutlet weak var oImagesButton: UIButton!
    @IBOutlet weak var uImagesButton: UIButton!
    @IBOutlet weak var storeRoomTextField: JVFloatLabeledTextField!
    @IBOutlet weak var laundryTextField: JVFloatLabeledTextField!
    @IBOutlet weak var diningRoomTextField: JVFloatLabeledTextField!
    @IBOutlet weak var livingRoomTextField: JVFloatLabeledTextField!
    @IBOutlet weak var bathroomTextField: JVFloatLabeledTextField!
    @IBOutlet weak var bedroomTextField: JVFloatLabeledTextField!
    @IBOutlet weak var propertyTitle: JVFloatLabeledTextField!
    @IBOutlet weak var descriptionTextField: JVFloatLabeledTextField!
    @IBOutlet weak var propertyOwner: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addressTextField: JVFloatLabeledTextField!
    @IBOutlet weak var suburbAreaTextField: JVFloatLabeledTextField!
    @IBOutlet weak var countryTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cityTextField: JVFloatLabeledTextField!
    @IBOutlet weak var landAreaTextField: JVFloatLabeledTextField!
    @IBOutlet weak var priceTextField: JVFloatLabeledTextField!
    @IBOutlet weak var propertyType: UILabel!
    @IBOutlet weak var contractType: UILabel!
    @IBOutlet weak var unitType: UILabel!
    @IBOutlet weak var currencyType: UILabel!
    
    let user = AppUser.getInst();
    var dropDowns : [DropDown] = [DropDown]();
    let CUR_TYPE = 0;
    let PROP_OWNR = 1;
    let PROP_TYPE = 2;
    let CONT_TYPE = 3;
    let UNIT_TYPE = 4;
    
    var imagesCollection = [PHAsset]();
    var oImagesCollection = [PHAsset]();
    var nImagesCollection = [PHAsset]();
    var uImagesCollection = [PHAsset]();
    var property : Property? ;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Add Property"
        addDropDowns();
        setLabelsActions();
        setCollectionView();
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        setTextFields();
    }
    
    
    func setTextFields() {
        
        bedroomTextField.addDoneButton(view: view)
        bathroomTextField.addDoneButton(view: view)
        livingRoomTextField.addDoneButton(view: view)
        diningRoomTextField.addDoneButton(view: view)
        storeRoomTextField.addDoneButton(view: view)
        laundryTextField.addDoneButton(view: view)
        maidRoomsTextField.addDoneButton(view: view);
        
        propertyTitle.setBottomBorderDark();
        landAreaTextField.setBottomBorderDark();
        priceTextField.setBottomBorderDark();
        descriptionTextField.setBottomBorderDark();
        addressTextField.setBottomBorderDark();
        suburbAreaTextField.setBottomBorderDark();
        cityTextField.setBottomBorderDark();
        countryTextField.setBottomBorderDark();
        bedroomTextField.setBottomBorderDark();
        bathroomTextField.setBottomBorderDark();
        livingRoomTextField.setBottomBorderDark();
        diningRoomTextField.setBottomBorderDark();
        storeRoomTextField.setBottomBorderDark();
        laundryTextField.setBottomBorderDark();
        maidRoomsTextField.setBottomBorderDark();
        
        propertyTitle.delegate = self;
        priceTextField.delegate = self;
        descriptionTextField.delegate = self;
        landAreaTextField.delegate = self;
        addressTextField.delegate = self;
        suburbAreaTextField.delegate = self;
        cityTextField.delegate = self;
        countryTextField.delegate = self;
        bedroomTextField.delegate = self;
        bathroomTextField.delegate = self;
        livingRoomTextField.delegate = self;
        diningRoomTextField.delegate = self;
        storeRoomTextField.delegate = self;
        laundryTextField.delegate = self;
        maidRoomsTextField.delegate = self;
    }
    func provideCompleteData(msg: String , callback: @escaping ()->Void) {
        self.showMessage(title: "Please Insert Complete Data", message: msg, doneButtonText: "Okey", cancelButtonText: "Cancel", done: callback, cancel: {})
    }
    
    @IBAction func submitProperty(_ sender: Any) {
        // Validate input Fields
        if propertyTitle.containsAnyValue(){
            if priceTextField.containsAnyValue(){
                if landAreaTextField.containsAnyValue(){
                    if let propertyOwner = dropDowns[PROP_OWNR].selectedItem{
                        if let currnecyType = dropDowns[CUR_TYPE].selectedItem{
                            if let unitType = dropDowns[UNIT_TYPE].selectedItem{
                                if let propType = dropDowns[PROP_TYPE].selectedItem{
                                    if addressTextField.containsAnyValue(){
                                        if cityTextField.containsAnyValue(){
                                            if countryTextField.containsAnyValue(){
                                                if bathroomTextField.containsAnyValue(){
                                                    if bedroomTextField.containsAnyValue(){
                                                        if (self.imagesCollection.count > 0){
                                                            if (self.nImagesCollection.count > 0){
                                                                if (self.uImagesCollection.count > 0){
                                                                    if (self.oImagesCollection.count > 0){
                                                                        let title = propertyTitle.text ?? "";
                                                                        let price = priceTextField.text ?? "";
                                                                        let landArea = landAreaTextField.text ?? ""
                                                                        let address = addressTextField.text ?? ""
                                                                        let city = cityTextField.text ?? ""
                                                                        let country = countryTextField.text  ?? ""
                                                                        let bathroomCount = bathroomTextField.text ?? ""
                                                                        let bedroomCount = bedroomTextField.text ?? ""
                                                                        let livingRoomsText = livingRoomTextField.text ?? ""
                                                                        let diningRoomText = diningRoomTextField.text ?? ""
                                                                        let storeRoomText = storeRoomTextField.text ?? ""
                                                                        let laundryText = laundryTextField.text ?? ""
                                                                        let maidsRoomText = maidRoomsTextField.text ?? ""
                                                                        let areaSuburbText = suburbAreaTextField.text ?? ""
                                                                        let contractTypeText = dropDowns[CONT_TYPE].selectedItem ?? ""
                                                                        let descripText = descriptionTextField.text ?? ""
                                                                        
                                                                        //Perform Network Request
                                                                        sendNetworkRequest(pOwner: propertyOwner, pCurType: currnecyType, pTitle: title, pPrice: price, pLandArea: landArea, pUnit: unitType, pContType: contractTypeText, pPropType: propType, pDescription: descripText, pCountry: country, pCity: city, pSuburb: areaSuburbText, pAddress: address, pBed: bedroomCount, pBath: bathroomCount, pLivingRoom: livingRoomsText, pDiningRoom: diningRoomText, pStoreRoom: storeRoomText, pLaundry: laundryText, pMaidRoom: maidsRoomText)
                                                                    }else{
                                                                        self.provideCompleteData(msg: "Please select atleast one ownership image", callback: {
                                                                            self.scrollView.scrollToView(view: self.oImagesCollectionView, animated: true);
                                                                            
                                                                        })
                                                                    }
                                                                }else{
                                                                    self.provideCompleteData(msg: "Please select atleast one Utility image", callback: {
                                                                        self.scrollView.scrollToView(view: self.uImagesCollectionView, animated: true);
                                                                        
                                                                    })
                                                                }
                                                            }else{
                                                                self.provideCompleteData(msg: "Please select atleast one neighborhood image", callback: {
                                                                    self.scrollView.scrollToView(view: self.nImagesCollectionView, animated: true);
                                                                })
                                                            }
                                                        }else{
                                                            self.provideCompleteData(msg: "Please select atleast one image", callback: {
                                                                self.scrollView.scrollToView(view: self.imagesCollectionView, animated: true);
                                                            })
                                                        }
                                                    }else{
                                                        self.bedroomTextField.becomeFirstResponder();
                                                    }
                                                }else{
                                                    self.bathroomTextField.becomeFirstResponder();
                                                }
                                            }else{
                                                self.provideCompleteData(msg: "Country field is empty", callback: {
                                                    self.countryTextField.becomeFirstResponder();
                                                })
                                            }
                                        }else{
                                            self.provideCompleteData(msg: "City field is empty", callback: {
                                                self.cityTextField.becomeFirstResponder();
                                            })
                                        }
                                    }else{
                                        self.provideCompleteData(msg: "Address is empty.", callback: {
                                            self.addressTextField.becomeFirstResponder();
                                        })
                                    }
                                    
                                }else{
                                    provideCompleteData(msg: "Property Type is not selected.", callback: {
                                        self.scrollView.scrollToView(view: self.propertyType, animated:false)
                                        self.dropDowns[self.PROP_TYPE].show();
                                    })
                                }
                            }else{
                                provideCompleteData(msg: "Unit Type is not selected.", callback: {
                                    self.scrollView.scrollToView(view: self.propertyType, animated:false)
                                    self.dropDowns[self.UNIT_TYPE].show();
                                })
                            }
                        }else{
                            provideCompleteData(msg: "Currency Type is not selected.", callback: {
                                self.scrollView.scrollToView(view: self.propertyType, animated:false)
                                self.dropDowns[self.CUR_TYPE].show();
                            })
                        }
                    }else{
                        provideCompleteData(msg: "Property Owner is not selected.", callback: {
                            self.scrollView.scrollToView(view: self.propertyType, animated:false)
                            self.dropDowns[self.PROP_OWNR].show();
                        })
                    }
                }else{
                    provideCompleteData(msg: "Land area is empty", callback: {
                        self.landAreaTextField.becomeFirstResponder();
                    })
                }
            }else{
                provideCompleteData(msg: "Property price is empty", callback: {
                    self.priceTextField.becomeFirstResponder();
                })
            }
        }else{
            provideCompleteData(msg: "Property title is empty", callback: {
                self.propertyTitle.becomeFirstResponder();
            })
        }
        // End Of Validation Data
    }
    
    func sendNetworkRequest(pOwner: String , pCurType: String , pTitle:String , pPrice:String , pLandArea :String , pUnit:String , pContType:String , pPropType:String , pDescription:String , pCountry :String , pCity:String , pSuburb:String , pAddress:String , pBed:String , pBath:String , pLivingRoom : String , pDiningRoom:String , pStoreRoom : String , pLaundry:String , pMaidRoom:String)  {
        //Create Blur View
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        // Create Progress View
        let progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
        progressRing.ringStyle = UICircularProgressRingStyle.inside
        progressRing.maxValue = 100
        progressRing.fontColor = UIColor.white;
        progressRing.innerRingColor = UIColor.cyan
        progressRing.outerRingColor = Constants.APP_COLOR
        let progressX = (view.frame.width/2 - 120);
        let progressY = (view.frame.height/2 - 120);
        progressRing.frame = CGRect(x: progressX , y: progressY, width: 240, height: 240);
        
        //Create Label
        let label  = UILabel(frame: CGRect(x: 0, y: (progressY+240), width: view.bounds.width, height: 80));
        label.text = "Adding Property..."
        label.textAlignment = .center
        label.textColor = Constants.APP_COLOR;
        
        // Add Progress and Label  To BlurView
        blurEffectView.addSubview(label);
        blurEffectView.addSubview(progressRing)
        
        
        let params : Parameters = [
            "user_id": user.userId!,
            "propert_owner":pOwner,
            "currnecy":pCurType,
            "title":pTitle,
            "price":pPrice,
            "land_area":pLandArea,
            "unit":pUnit,
            "contract_type":pContType,
            "property_type":pPropType,
            "description":pDescription,
            "country":pCountry,
            "city":pCity,
            "suburb":pSuburb,
            "address":pAddress,
            "bed":pBed,
            "bath":pBath,
            "living_rooms":pLivingRoom,
            "dining_rooms":pDiningRoom,
            "store_rooms":pStoreRoom,
            "laundry":pLaundry,
            "maids_rooms":pMaidRoom,
            "images":"[]",
            "neighbor_images":"[]",
            "utility_images":"[]",
            "ownership_images":"[]"
        ]
        Alamofire.request(URLs.ADD_NEW_PROPERTY, method: .post, parameters: params)
            .responseString { res in
                switch(res.result){
                case .success(let res):
                    if let data = res.data(using: .utf8, allowLossyConversion: false) {
                        self.property = Property(json: JSON(data));
                        self.startUploadingImages(property: self.property!, blurView: blurEffectView, progressView: progressRing, labelView: label)
                    }
                    break;
                case .failure( _):
                    self.showMessage(title: "Fail to add property", message: "Cannot upload images to the server", doneButtonText: "Retry", cancelButtonText: "Cancel", done: {
                        print("Error ")
                    }, cancel: {
                        self.navigationController?.popViewController(animated: true);
                    })
                    break;
                }
        }
        
    }
    
    func startUploadingImages(property:Property , blurView:UIVisualEffectView , progressView : UICircularProgressRingView , labelView: UILabel)  {
        labelView.text = "Uploading Images..."
        Uploader.getInst().uploadPropertyImage(property: property, propImages: self.imagesCollection, nPropImages: self.nImagesCollection, uPropImages: self.uImagesCollection, oPropImages: self.oImagesCollection, progressClosure: { progress in
            // onProgress Changed
            print("Upload Progress : \(progress.fractionCompleted*100)")
            progressView.setProgress(value: CGFloat(progress.fractionCompleted*100),animationDuration: 0.4);
            
        }, completed: {
            // On Completed
            print("Adding Property Completed")
            blurView.removeFromSuperview();
            self.showMessage(title: "Property Added", message: "Property added successfully but pending admin approval", doneButtonText: "Ok", cancelButtonText: "Cancel", done: {
                self.navigationController?.popViewController(animated: true);
            }, cancel: {
                self.navigationController?.popViewController(animated: true);
            })
        }) {//onError
            print("Error Uploading AddPropertyViewController")
            self.showMessage(title: "Fail to add property", message: "Cannot upload images to the server", doneButtonText: "Retry", cancelButtonText: "Cancel", done: {
                
            }, cancel: {
                self.navigationController?.popViewController(animated: true);
            })
            blurView.removeFromSuperview();
        }
    }
    
    @IBAction func addImages(_ sender: Any) {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .denied || status == .restricted) {
            self.showMessage(title: "Oops", message: "Access to PHPhoto library is denied.", doneButtonText: "Ok", cancelButtonText: nil, done: {}, cancel: nil);
            return
        }else{
            self.imagesCollection.removeAll();
            self.imagesCollectionView.reloadData();
            addImages(oneSelection: { asset in
                
            }, oneDeselection: { asset in
                
            }, cancelAll: { assets in
                
            }, addedAll: {assets in
                for asset in assets{
                    print(asset.creationDate.debugDescription)
                    self.imagesCollection.append(asset);
                }
                self.imagesCollectionView.reloadData();
            })
        }
        
    }
    
    @IBAction func addOImages(_ sender: Any) {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .denied || status == .restricted) {
            self.showMessage(title: "Oops", message: "Access to PHPhoto library is denied.", doneButtonText: "Ok", cancelButtonText: nil, done: {}, cancel: nil);
            return
        }else{
            self.oImagesCollection.removeAll();
            self.oImagesCollectionView.reloadData();
            addImages(oneSelection: { asset in
                
            }, oneDeselection: { asset in
                
            }, cancelAll: { assets in
                
            }, addedAll: {assets in
                for asset in assets{
                    print(asset.creationDate.debugDescription)
                    self.oImagesCollection.append(asset);
                }
                self.oImagesCollectionView.reloadData();
            })
        }
        
    }
    @IBAction func addUImages(_ sender: Any) {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .denied || status == .restricted) {
            self.showMessage(title: "Oops", message: "Access to PHPhoto library is denied.", doneButtonText: "Ok", cancelButtonText: nil, done: {}, cancel: nil);
            return
        }else{
            self.uImagesCollection.removeAll();
            self.uImagesCollectionView.reloadData()
            addImages(oneSelection: { asset in
                
            }, oneDeselection: { asset in
                
            }, cancelAll: { assets in
                
            }, addedAll: {assets in
                for asset in assets{
                    print(asset.creationDate.debugDescription)
                    self.uImagesCollection.append(asset);
                }
                self.uImagesCollectionView.reloadData();
            })
        }
        
    }
    let nActivty = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    @IBAction func addNImages(_ sender: Any) {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .denied || status == .restricted) {
            self.showMessage(title: "Oops", message: "Access to PHPhoto library is denied.", doneButtonText: "Ok", cancelButtonText: nil, done: {}, cancel: nil);
            return
        }else{
            self.nImagesCollection.removeAll();
            self.nImagesCollectionView.reloadData();
            addImages(oneSelection: { asset in
                
            }, oneDeselection: { asset in
                
            }, cancelAll: { assets in
                
            }, addedAll: {assets in
                for asset in assets{
                    print(asset.creationDate.debugDescription)
                    self.nImagesCollection.append(asset);
                }
                self.nImagesCollectionView.reloadData();
            })
        }
        
    }
    
    
    func addDropDowns()  {
        dropDowns.append(DropDown());
        dropDowns.append(DropDown());
        dropDowns.append(DropDown());
        dropDowns.append(DropDown());
        dropDowns.append(DropDown());
        dropDowns.forEach({ (dd) in
            dd.direction = .bottom
        })
        
        dropDowns.forEach({ (dd) in
            dd.dismissMode = .onTap
        })
        var count = 0;
        dropDowns.forEach({(dd) in
            switch(count){
            case PROP_OWNR:
                dd.dataSource = ["Our Company", "None"];
                break
            case CUR_TYPE:
                dd.dataSource = ["Dollar","EUR","PKR","DHR"];
                break
            case PROP_TYPE:
                dd.dataSource = ["House","Flat","Lower Portion","Shop","Upper Portion","Office Area","Townhouse"];
                break
            case UNIT_TYPE:
                dd.dataSource = ["Square Feet","Square Yards","Square Meter","Marla","Kanal"];
                break
            case CONT_TYPE:
                dd.dataSource = ["Appartment","Banglow","Duplex","Town House","Villa"];
                break;
            default:
                
                break
            }
            count += 1;
        })
    }
    
    
    func setLabelsActions()  {
        propertyOwner.isUserInteractionEnabled = true;
        propertyOwner.setBoldAndRegularTitle(boldString: "Property Owner: ", regularString: "Select", boldFontSize: 16, regularFontSize: 16)
        dropDowns[PROP_OWNR].anchorView = propertyOwner;
        dropDowns[PROP_OWNR].selectionAction = {[unowned self] (index,item) in
            self.propertyOwner.setBoldAndRegularTitle(boldString: "Property Owner: ", regularString: item, boldFontSize: 16, regularFontSize: 16)
        }
        
        currencyType.isUserInteractionEnabled = true;
        currencyType.setBoldAndRegularTitle(boldString: "Currency Type: ", regularString: "Select", boldFontSize: 16, regularFontSize: 16)
        dropDowns[CUR_TYPE].anchorView = currencyType;
        dropDowns[CUR_TYPE].selectionAction = {[unowned self] (index,item) in
            self.currencyType.setBoldAndRegularTitle(boldString: "Currency Type: ", regularString: item, boldFontSize: 16, regularFontSize: 16)
        }
        
        propertyType.isUserInteractionEnabled = true;
        propertyType.setBoldAndRegularTitle(boldString: "Property Type: ", regularString: "Select", boldFontSize: 16, regularFontSize: 16)
        dropDowns[PROP_TYPE].anchorView = propertyType;
        dropDowns[PROP_TYPE].selectionAction = {[unowned self] (index,item) in
            self.propertyType.setBoldAndRegularTitle(boldString: "Property Type: ", regularString: item, boldFontSize: 16, regularFontSize: 16)
        }
        
        contractType.isUserInteractionEnabled = true;
        contractType.setBoldAndRegularTitle(boldString: "Contract Type: ", regularString: "Select", boldFontSize: 16, regularFontSize: 16)
        dropDowns[CONT_TYPE].anchorView = contractType;
        dropDowns[CONT_TYPE].selectionAction = {[unowned self] (index,item) in
            self.contractType.setBoldAndRegularTitle(boldString: "Contract Type: ", regularString: item, boldFontSize: 16, regularFontSize: 16)
        }
        
        unitType.isUserInteractionEnabled = true;
        unitType.setBoldAndRegularTitle(boldString: "Unit Type: ", regularString: "Select", boldFontSize: 16, regularFontSize: 16)
        dropDowns[UNIT_TYPE].anchorView = unitType;
        dropDowns[UNIT_TYPE].selectionAction = {[unowned self] (index,item) in
            self.unitType.setBoldAndRegularTitle(boldString: "Unit Type: ", regularString: item, boldFontSize: 16, regularFontSize: 16)
        }
        
        dropDowns.forEach({dd in
            // Top of drop down will be below the anchorView
            dd.bottomOffset = CGPoint(x: 0, y:(dd.anchorView?.plainView.bounds.height)!)
        })
        
        propertyOwner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPropertyOwner(_:))))
        currencyType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCurrencyType(_:))))
        propertyType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPropertyType(_:))))
        contractType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showContractType(_:))))
        unitType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUnitType(_:))))
        
    }
    
    func showPropertyOwner(_ sender: Any) {
        dropDowns[PROP_OWNR].show()
    }
    func showCurrencyType(_ sender: Any) {
        dropDowns[CUR_TYPE].show()
    }
    func showPropertyType(_ sender:Any)  {
        dropDowns[PROP_TYPE].show()
    }
    func showContractType(_ sender:Any) {
        dropDowns[CONT_TYPE].show()
    }
    func showUnitType(_ sender : Any)  {
        dropDowns[UNIT_TYPE].show()
    }
    
    //////// Start of Keyboard Functions /////////////////////////
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.next) {
            if textField == propertyTitle {
                priceTextField.becomeFirstResponder();
            }else if textField == priceTextField{
                landAreaTextField.becomeFirstResponder();
            }else if textField == landAreaTextField{
                descriptionTextField.becomeFirstResponder();
            }else if textField == addressTextField{
                suburbAreaTextField.becomeFirstResponder();
            }else if textField == suburbAreaTextField{
                cityTextField.becomeFirstResponder();
            }else if textField == cityTextField{
                countryTextField.becomeFirstResponder();
            }else if textField == countryTextField{
                bedroomTextField.becomeFirstResponder();
            }else if textField == bedroomTextField{
                bathroomTextField.becomeFirstResponder();
            }else if textField == bathroomTextField{
                livingRoomTextField.becomeFirstResponder();
            }else if textField == livingRoomTextField{
                diningRoomTextField.becomeFirstResponder();
            }else if textField == diningRoomTextField{
                storeRoomTextField.becomeFirstResponder();
            }else if textField == storeRoomTextField{
                laundryTextField.becomeFirstResponder();
            }else if textField == laundryTextField{
                maidRoomsTextField.becomeFirstResponder();
            }
            
            return true;
        }else{
            textField.resignFirstResponder()
            return true;
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.layer.position.y > 250) {
            scrollView.setContentOffset(CGPoint(x: 0, y: (textField.layer.position.y - 210)), animated: true);
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true);
    }
    //////// End of Keyboard Funcitons /////////////////////////////
    
    
    //////////////////////////////////////////////////////////////////////
    //// Images Work Start///////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////
    
    /// Setting NIB for ColectionView
    func setCollectionView()  {
        let nib = UINib(nibName: "ImageViewCell", bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "ImageViewCell")
        imagesCollectionView.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ImageViewCell")
        imagesCollectionView.delegate = self;
        imagesCollectionView.dataSource = self
        
        let onib = UINib(nibName: "ImageViewCell", bundle: nil)
        oImagesCollectionView.register(onib, forCellWithReuseIdentifier: "ImageViewCell")
        oImagesCollectionView.register(onib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ImageViewCell")
        oImagesCollectionView.delegate = self;
        oImagesCollectionView.dataSource = self
        
        let nnib = UINib(nibName: "ImageViewCell", bundle: nil)
        nImagesCollectionView.register(nnib, forCellWithReuseIdentifier: "ImageViewCell")
        nImagesCollectionView.register(nnib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ImageViewCell")
        nImagesCollectionView.delegate = self;
        nImagesCollectionView.dataSource = self
        
        let unib = UINib(nibName: "ImageViewCell", bundle: nil)
        uImagesCollectionView.register(unib, forCellWithReuseIdentifier: "ImageViewCell")
        uImagesCollectionView.register(unib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ImageViewCell")
        uImagesCollectionView.delegate = self;
        uImagesCollectionView.dataSource = self
        
    }
    
    
    /// Add Images As Functional way
    func addImages(oneSelection : @escaping (PHAsset)->Void , oneDeselection : @escaping (PHAsset)->Void , cancelAll : @escaping ([PHAsset])->Void , addedAll : @escaping ([PHAsset])->Void)  {
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 5;
        vc.selectionFillColor = Constants.APP_COLOR;
        bs_presentImagePickerController(vc, animated: true, select: oneSelection, deselect: oneDeselection, cancel: cancelAll, finish: addedAll, completion: nil)
    }
    
    
    
    /// Delete Selected Images if User need to do...
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imagesCollectionView{
            let action1 = UIAlertAction(title: "Remove Selected", style: .default, handler: { action in
                self.imagesCollection.remove(at: indexPath.row);
                self.imagesCollectionView.reloadData();
            })
            let action2 = UIAlertAction(title: "Remove All", style: .default, handler: { action in
                self.imagesCollection.removeAll();
                self.imagesCollectionView.reloadData();
            })
            let action3 = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                
            })
            self.showAlertSheetWith(actions: [action1,action2,action3], title: "Remove selected image ?", message: "")
        }else if collectionView == oImagesCollectionView{
            let action1 = UIAlertAction(title: "Remove Selected", style: .default, handler: { action in
                self.oImagesCollection.remove(at: indexPath.row);
                self.oImagesCollectionView.reloadData();
            })
            let action2 = UIAlertAction(title: "Remove All", style: .default, handler: { action in
                self.oImagesCollection.removeAll();
                self.oImagesCollectionView.reloadData();
            })
            let action3 = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                
            })
            self.showAlertSheetWith(actions: [action1,action2,action3], title: "Remove selected image ?", message: "")
        }else if collectionView == uImagesCollectionView{
            let action1 = UIAlertAction(title: "Remove Selected", style: .default, handler: { action in
                self.uImagesCollection.remove(at: indexPath.row);
                self.uImagesCollectionView.reloadData();
            })
            let action2 = UIAlertAction(title: "Remove All", style: .default, handler: { action in
                self.uImagesCollection.removeAll();
                self.uImagesCollectionView.reloadData();
            })
            let action3 = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                
            })
            self.showAlertSheetWith(actions: [action1,action2,action3], title: "Remove selected image ?", message: "")
        }else if collectionView == nImagesCollectionView{
            let action1 = UIAlertAction(title: "Remove Selected", style: .default, handler: { action in
                self.nImagesCollection.remove(at: indexPath.row);
                self.nImagesCollectionView.reloadData();
            })
            let action2 = UIAlertAction(title: "Remove All", style: .default, handler: { action in
                self.nImagesCollection.removeAll();
                self.nImagesCollectionView.reloadData();
            })
            let action3 = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                
            })
            self.showAlertSheetWith(actions: [action1,action2,action3], title: "Remove selected image ?", message: "")
        }
    }
    
    // Counts For All CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagesCollectionView{
            return imagesCollection.count;
        }else if collectionView == oImagesCollectionView{
            return oImagesCollection.count;
        }else if collectionView == uImagesCollectionView{
            return uImagesCollection.count;
        }else if collectionView == nImagesCollectionView{
            return nImagesCollection.count;
        }else{
            return 0;
        }
    }
    
    //Cell For All CollectionViews
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell;
            cell.image.showLoadingSd()
            cell.image.image = getAssetThumbnail(asset: imagesCollection[indexPath.row]);
            cell.image.applyListingShadow()
            return cell;
        }else if collectionView == oImagesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell;
            cell.image.showLoadingSd()
            cell.image.image = getAssetThumbnail(asset: oImagesCollection[indexPath.row]);
            cell.image.applyListingShadow()
            return cell;
        }else if collectionView == uImagesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell;
            cell.image.showLoadingSd()
            cell.image.image = getAssetThumbnail(asset: uImagesCollection[indexPath.row]);
            cell.image.applyListingShadow()
            return cell;
        }else if collectionView == nImagesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell;
            print("Image Loaded Successfully")
            /**/
            cell.image.showLoadingSd()
            cell.image.image = getAssetThumbnail(asset: nImagesCollection[indexPath.row]);
            cell.image.applyListingShadow()
            return cell;
        }else{
            return UICollectionViewCell();
        }
    }
    
    // Image Loader for Cell
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
    /////////////////////////////////////////////////////////////////
    ////Image Work End//////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////
}
