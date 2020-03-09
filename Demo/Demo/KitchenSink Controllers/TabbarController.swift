//
//  TabbarController.swift
//  BlibliMobile-iOS
//
//  Created by Ashok Kumar on 30/05/19.
//  Copyright © 2019 Global Digital Niaga, PT. All rights reserved.
//

import UIKit
import CommonUIKit

enum BM_AppTab : String {
    case categoryTab = "category"
    case homeTab = "home"
    
    case cartTab = "cart"
    case accountTab = "account"
    case wishlistTab = "wishlist"
}

class TabbarController: UITabBarController, CustomTabbarDelegate {

    @IBOutlet weak var customTabbar: CustomTabbar!
    
    var previousSelectedTabbarIndex = 0
    var tabSequence : [BM_AppTab] = [.homeTab,.cartTab,.wishlistTab]
    var tabViewControllers : [UIViewController] = [UIViewController]()

    var mainPanelVC: FloatingPanelController?
    var vc: CommonTableViewController?
    
    var presenter = UIViewController()
    
    override func viewDidLoad() {
    
        //self.tabBar.delegate = self
        //BM_CartManager().updateCartCountFromApi { (_) in }
        tabSequence.forEach { (tab) in
            switch tab {
            case .homeTab :
                let helper = ProductListHelper()
                let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
                helper.controller = controller
                
                let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ProductListViewController")
                destinationVC?.view.backgroundColor = UIColor.clear
                let navController = VC1(rootViewController: controller)
                tabViewControllers.append(navController)
            case .cartTab :
                let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ProductListViewController")
                destinationVC?.view.backgroundColor = UIColor.green
                let navController = VC2(rootViewController: destinationVC!)
                tabViewControllers.append(navController)
            case .wishlistTab :
                let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ProductListViewController")
                destinationVC?.view.backgroundColor = UIColor.blue
                let navController = VC3(rootViewController: destinationVC!)
                tabViewControllers.append(navController)
            default:
                break
                
            }
        }
        self.viewControllers = self.tabViewControllers
        
        super.viewDidLoad()
        
        //animateTabbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        customTabbar.delegate_ = self
    }
    
    func animateTabbar() {
        
        let originalFrame = customTabbar.frame
        
        var tabbarRect = originalFrame
        tabbarRect.origin.y = tabbarRect.maxY
        customTabbar.frame = tabbarRect
        
        UIView.animate(withDuration: 0.5) {
            self.customTabbar.frame = originalFrame
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 1, let _ = tabBar as? CustomTabbar {
            
            //tabbar.didTapBag(tabbar.cartButton)
            showDropDown()
            self.selectedIndex = previousSelectedTabbarIndex
            
        } else {
            previousSelectedTabbarIndex = item.tag
        }
    }
    
    func didTapBag(_ sender: UIButton, parent: Any) {
        showDropDown()
    }
    
    func openBottomSheet(with controller: UIViewController) {
        
        //if let topController = UIApplication.shared.keyWindow?.visibleViewController() {
        if let top = UIApplication.topMost as? TabbarController, let topController = (top.selectedViewController as? UINavigationController)?.topViewController {
            
            mainPanelVC = FloatingPanelController()
            mainPanelVC?.modalPresentationStyle = .overFullScreen
            mainPanelVC?.delegate = self
            mainPanelVC?.setVibrancyAlpha(withValue: 0.9)
            mainPanelVC?.surfaceView.cornerRadius_ = 10.0
            mainPanelVC?.surfaceView.shadowHidden = false
            mainPanelVC?.set(contentViewController: controller)
            mainPanelVC?.addPanel(toParent: topController, belowView: nil, animated: true)
            mainPanelVC?.updateLayout()
            //mainPanelVC?.view.frame = UIApplication.shared.keyWindow!.frame
            //UIApplication.shared.keyWindow?.addSubview((mainPanelVC?.view)!)
            //UIApplication.shared.keyWindow?.bringSubviewToFront((mainPanelVC?.view)!)

            //self.tabBar.layer.zPosition = -1
        }
    }
}

protocol BM_AppTabsControllerProtocol : NSObjectProtocol {
    func prepareTabItem()
}

class VC1: UINavigationController {
    override func viewDidLoad() {
        tabBarItem.tag = 0
        tabBarItem.image = UIImage(named: "home")
        tabBarItem.image = UIImage(named: "home_selected")
    }
}

class VC2: UINavigationController {
    override func viewDidLoad() {
        tabBarItem.isEnabled = false
        tabBarItem.tag = 1
        //tabBarItem.image = UIImage(named: "home")
        //tabBarItem.image = UIImage(named: "home_selected")
    }
}

class VC3: UINavigationController {
    override func viewDidLoad() {
        tabBarItem.tag = 2
        tabBarItem.image = UIImage(named: "category")
        tabBarItem.image = UIImage(named: "category_selected")
    }
}

extension TabbarController {
    
    func showDropDown() {
        
        let model1 = CustomSelectModel(withText: "Option 1 to check whether the tableview is growing in its size if multiple lines of text is given", horizontalAlignment: .right)
        
        let model2 = CustomSelectModel(withText: "Option 2", selectionMode: .selected, horizontalAlignment: .right, verticalAlignment: .top)
        
        let model3 = CustomSelectModel(withText: "Option 3", horizontalAlignment: .right)
        
        let model4 = CustomSelectModel(withText: "Option 4", horizontalAlignment: .right, isEnabled: false)
        
        let model5 = CustomSelectModel(withText: "Option 5 to check whether the tableview is growing in its size if multiple lines of text is given", horizontalAlignment: .right, isEnabled: false)
        
        let model6 = CustomSelectModel(withText: "Option 6 to check whether the tableview is growing in its size if multiple lines of text is given", horizontalAlignment: .right, isEnabled: false)
        
        let model7 = CustomSelectModel(withText: "Option 7 to check whether the tableview is growing in its size if multiple lines of text is given", horizontalAlignment: .right, isEnabled: false)
        
        let model8 = CustomSelectModel(withText: "Option 8 to check whether the tableview is growing in its size if multiple lines of text is given", horizontalAlignment: .right, isEnabled: false)
        
        let model9 = CustomSelectModel(withText: "Option 9 to check whether the tableview is growing in its size if multiple lines of text is given", horizontalAlignment: .right, isEnabled: false)
        
        let model10 = CustomSelectModel(withText: "Option 10", horizontalAlignment: .right, isEnabled: false)
        
        let dropdownHelper = DropDownHelper.shared
        dropdownHelper.dropdownTitle = "Title goes here"
        dropdownHelper.datasource = [model1, model2, model3, model4, model5, model6, model7, model8, model9, model10]
        let tvc = CommonTableViewController.instantiate(dataSource: dropdownHelper, delegate: dropdownHelper)
        dropdownHelper.controller = tvc
        
        self.openBottomSheet(with: tvc)
        //dropdownHelper.addPanel(with: dropdownHelper, controller: tvc, to: self)
        
//        ForceUpdate().show()
        
//        self.show()
    }
    
    func show() {
        
        if let topController = UIApplication.topMost {
            self.presenter = UIViewController()
            self.presenter.view.backgroundColor = .clear
            self.presenter.modalPresentationStyle = .overFullScreen
            topController.present(presenter, animated: false, completion: {
                self.showSheet()
            })
        }
    }
    
    func showSheet() {
        
        if let topController = UIApplication.topMost {
            
            if let mainPanelVC = self.mainPanelVC {
                mainPanelVC.removePanelFromParent(animated: true) {
                    self.showForceUpdatePopup(on: topController)
                }
            } else {
                self.showForceUpdatePopup(on: topController)
            }
            
        }
    }
    
    func showForceUpdatePopup(on: UIViewController) {
        
        //        mainPanelObserves.removeAll()
        
        mainPanelVC = FloatingPanelController()
//        let helper = FloatingPanelDelegate()
//        mainPanelVC?.delegate = helper
        mainPanelVC?.modalPresentationStyle = .overFullScreen
        mainPanelVC?.setVibrancyAlpha(withValue: 0.95)
        mainPanelVC?.surfaceView.cornerRadius_ = 10.0
        mainPanelVC?.surfaceView.shadowHidden = false
        mainPanelVC?.surfaceView.grabberHandle.isHidden = true
        mainPanelVC?.isRemovalInteractionEnabled = false
        
//        let helper = ForeUpdateHelper()
//        let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
//        helper.controller = controller
        
        let controller = getForceUpdateView()
        mainPanelVC?.set(contentViewController: controller)
        
        mainPanelVC?.addPanel(toParent: on, belowView: nil, animated: true)
        //        mainPanelVC?.updateLayout()
        
    }
    
    func getForceUpdateView() -> UIViewController {
        
        let viewController = UIViewController()
        
        let view = UIView()
        
        var rect = viewController.view.frame
        rect.size.height = 470.0
        view.frame = rect
        viewController.view.addSubview(view)
        
        view.showEmptyState(withTitle: NSAttributedString(string: "New Day, New Version"), description: NSAttributedString(string: "You need the latest app version to go to Blibli.com and continue shopping. Update now to get back in style!"), image: UIImage(named: "empty_cart") , buttonTitle: NSAttributedString(string: "Update Now"), completion: { (_) in
            
        })
        
        return viewController
    }
}

extension TabbarController: FloatingPanelControllerDelegate, FloatingPanelLayout {
    
    public func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return nil
    }
    
    public func floatingPanel(_ vc: FloatingPanelController, shouldRecognizeSimultaneouslyWith gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public var initialPosition: FloatingPanelPosition {
        return .half
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.half]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return 120.0
        case .half:
            return 500.0
            //return getContentViewHeight(from: vc)
        case .tip, .hidden: return 0.0
        }
    }
}

extension UIApplication{
    var topViewC: UIViewController?{
        if keyWindow?.rootViewController == nil{
            return keyWindow?.rootViewController
        }
        
        var pointedViewController = keyWindow?.rootViewController
        
        while  pointedViewController?.presentedViewController != nil {
            switch pointedViewController?.presentedViewController {
            case let navagationController as UINavigationController:
                pointedViewController = navagationController.viewControllers.last
            case let tabBarController as UITabBarController:
                pointedViewController = tabBarController.selectedViewController
            default:
                pointedViewController = pointedViewController?.presentedViewController
            }
        }
        return pointedViewController
        
    }
}

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        switch(vc){
        case is UINavigationController:
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            
        case is UITabBarController:
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            
        default:
            if let presentedViewController = vc.presentedViewController {
                //print(presentedViewController)
                if let presentedViewController2 = presentedViewController.presentedViewController {
                    return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController2)
                }
                else{
                    return vc;
                }
            }
            else{
                return vc;
            }
        }
        
    }
    
}

extension UIViewController {
    class func topViewController(rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        guard let presented = rootViewController.presentedViewController else {
            return rootViewController
        }
        
        switch presented {
        case let navigationController as UINavigationController:
            return topViewController(rootViewController: navigationController.viewControllers.last)
            
        case let tabBarController as UITabBarController:
            return topViewController(rootViewController: tabBarController.selectedViewController)
            
        default:
            return topViewController(rootViewController: presented)
        }
    }
}
