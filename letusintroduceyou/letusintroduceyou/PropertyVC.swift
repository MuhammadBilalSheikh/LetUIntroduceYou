//
//  PropertyVC.swift
//  letusintroduceyou
//
//  Created by Admin on 07/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class PropertyVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var lastSelectedIndex = 0;
    var allVc : [UIViewController] = [UIViewController]();
    var user : AppUser?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = AppUser.getInst();
        self.navigationController?.title  = "Property";
        segmentedControl.removeAllSegments()
        switch user!.currentUserType! {
        case "Buyer":
            print("Buyer")
            addBuyerData();
            break
        case "Agent":
            print("Agent")
            addAgentData();
            break
        default:
            print("Other")
        }
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        setupView();
    }
    private func addAgentData(){
        segmentedControl.insertSegment(withTitle: "Manage", at: 0, animated: false)
        allVc.append(managePropertyVC);
        segmentedControl.insertSegment(withTitle: "Offered", at: 1, animated: false)
        allVc.append(offeredPropertyVC);
        segmentedControl.insertSegment(withTitle: "Sold", at: 2, animated: false)
        allVc.append(soldPropertyVC)
        segmentedControl.insertSegment(withTitle: "Favourite", at: 3, animated: false)
        allVc.append(favouritePropertyVC)
        
        
        
    }
    private func addBuyerData(){
        segmentedControl.insertSegment(withTitle: "Bidded Property", at: 0, animated: false)
        allVc.append(biddedPropertyVC)
        segmentedControl.insertSegment(withTitle: "Purchased", at: 1, animated: false)
        allVc.append(purchasedPropertyVC)
        segmentedControl.insertSegment(withTitle: "Favourite", at: 2, animated: false)
        allVc.append(favouritePropertyVC)
    }
    
    private func setupView() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action:  #selector(swiped(sender:)));
        rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action:  #selector(swiped(sender:)));
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        updateView()
    }
    
    func swiped(sender:UISwipeGestureRecognizer){
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.right:
            print("Right -- ")
            let index = segmentedControl.selectedSegmentIndex-1;
            if index < 0{
                return
            }
            segmentedControl.selectedSegmentIndex = index;
            updateView();
            
        case UISwipeGestureRecognizerDirection.left:
            print("Left ++ ")
            let index = segmentedControl.selectedSegmentIndex+1;
            if index == allVc.count{
                return
            }
            segmentedControl.selectedSegmentIndex = index;
            updateView();
        default:
            break
        }
    }
    
    private func updateView() {
        remove(asChildViewController: allVc[lastSelectedIndex])
        add(asChildViewController: allVc[segmentedControl.selectedSegmentIndex])
        lastSelectedIndex = segmentedControl.selectedSegmentIndex;
    }
    
    //SegmentedControl Action
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        // Add Child View as Subview
        view.addSubview(viewController.view)
        // Configure Child View
        let mainBounds = view.bounds;
        let h = (mainBounds.height - (self.tabBarController!.tabBar.frame.height + self.navigationController!.navigationBar.frame.height+20));
        viewController.view.frame = CGRect(x: mainBounds.origin.x, y: (navigationController?.navigationBar.frame.maxY)!, width: mainBounds.width, height: h)//view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    
    //// All View Controllers
    private lazy var managePropertyVC: ManagePropertyVC = {
        let storyboard = self.storyboard!;
        var viewController = storyboard.instantiateViewController(withIdentifier: "ManagePropertyVC") as! ManagePropertyVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var offeredPropertyVC: OfferedPropertyVC = {
        let storyboard = self.storyboard!;
        var viewController = storyboard.instantiateViewController(withIdentifier: "OfferedPropertyVC") as! OfferedPropertyVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var soldPropertyVC: SoldPropertyVC = {
        let storyboard = self.storyboard!;
        var viewController = storyboard.instantiateViewController(withIdentifier: "SoldPropertyVC") as! SoldPropertyVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var favouritePropertyVC: FavouritePropertyVC = {
        let storyboard = self.storyboard!;
        var viewController = storyboard.instantiateViewController(withIdentifier: "FavouritePropertyVC") as! FavouritePropertyVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var biddedPropertyVC: BiddedPropertyVC = {
        let storyboard = self.storyboard!;
        var viewController = storyboard.instantiateViewController(withIdentifier: "BiddedPropertyVC") as! BiddedPropertyVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var purchasedPropertyVC: PurchasedPropertyVC = {
        let storyboard = self.storyboard!;
        var viewController = storyboard.instantiateViewController(withIdentifier: "PurchasedPropertyVC") as! PurchasedPropertyVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
}
