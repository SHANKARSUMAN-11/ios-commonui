//
//  UtilityMethods.swift
//  CommonUIKit
//
//  Created by Prince Mathew on 13/02/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import Foundation
@objc protocol CustomBackButtonDelegate: class {
    @objc func backToPreviousController()
}

public class UtilityMethods: NSObject {
    
    static func customBackButton(navigationController: UINavigationController?, navigationItem: UINavigationItem?,responder: CustomBackButtonDelegate?, image: UIImage?) {
        let customBackBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: responder, action: #selector(responder.self?.backToPreviousController))
        customBackBarButtonItem.customView?.frame.size.width = 44
        customBackBarButtonItem.customView?.frame.size.height = 44
        navigationItem?.leftBarButtonItem = customBackBarButtonItem
    }
    
    static func set(backgroundColor: UIColor,foregroundColor: UIColor, for navBar: UINavigationBar) {
        navBar.barTintColor = backgroundColor
        navBar.tintColor = foregroundColor
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: foregroundColor]
    }
    
    public static func getView(with identifier:String) -> UIView? {
        
        var returnView: UIView? = nil
        if let _ = Bundle.main.path(forResource: identifier, ofType: "nib"),
            let customviewClass = self.getClass(from: identifier),
            let tempView = Bundle.main.loadNibNamed(identifier, owner: nil, options: nil)?.first as? UIView,
            tempView.classForCoder == customviewClass {
            returnView = tempView
        } else if let viewClass = self.getClass(from: identifier),
            let viewType = viewClass as? UIView.Type {
            returnView = viewType.init()
            let bundle = Bundle(for: viewClass)
            
            if bundle.path(forResource: "\(viewClass)", ofType: "nib") != nil,
                returnView?.subviews.first == nil,
                let tempView =  UINib(nibName: "\(viewClass)", bundle: bundle).instantiate(withOwner: bundle, options: nil).first as? UIView {
                returnView = tempView
            }
        }
        
        return returnView
    }
    
    static func getViewController(with identifier:String) -> UIViewController? {
        
        var returnView: UIViewController? = nil
        if let _ = Bundle.main.path(forResource: identifier, ofType: "nib"),
            let tempView = (Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?[0] as? UIViewController) {
            returnView = tempView
        } else if let viewType = self.getClass(from: identifier) as? UIViewController.Type {
            returnView = viewType.init()
        }
        return returnView
    }
    
    static func getClass(from className: String) -> AnyClass? {
    
        if let bundleName =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String,
            let cls = NSClassFromString("\(bundleName).\(className)") {
            return cls
        } else if let cls = NSClassFromString("CommonUIKit.\(className)") {
            return cls
        } else if let cls = NSClassFromString(className) {
            return cls
        }
        return nil
    }
}
