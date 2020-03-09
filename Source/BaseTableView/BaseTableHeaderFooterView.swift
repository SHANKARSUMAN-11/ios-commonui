//
//  BaseTableHeaderFooterView.swift
//  CommonUIKit
//
//  Created by Jimmy Julius Harijanto on 11/9/17.
//  Copyright © 2017 Coviam. All rights reserved.
//

import UIKit

public class BaseTableHeaderFooterView: UITableViewHeaderFooterView {
    
    public var customView: UIView?
    public var leadingTrailingConstraint : [NSLayoutConstraint]?
    public var topBottomConstraint : [NSLayoutConstraint]?

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.initializeCustomView(identifier: reuseIdentifier)
    }
    
    func initializeCustomView(identifier: String?) {
        guard let identifier = identifier else {
            print("You just passed nil identifier while registering BM_BaseTableViewHeaderFooterView")
            return
        }
        guard let tempView = UtilityMethods.getView(with: identifier) else {
            print("View class \(identifier) not found (Check Target membership)")
            return
        }
        self.addSubViewToContentView(tempView: tempView)
    }
    
    fileprivate func addSubViewToContentView(tempView:UIView) {
        customView = tempView
        contentView.addSubview(tempView)
        customView?.translatesAutoresizingMaskIntoConstraints = false
        addCustomViewConstraintWith(horizontalOffset: 0.0, verticalOffset: 0.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setCard(horizontalOffset: CGFloat, verticalOffset: CGFloat, contentViewBackgroundColor: UIColor = UIColor.groupTableViewBackground) {
        contentView.backgroundColor = contentViewBackgroundColor
        if let leadingTrailing = leadingTrailingConstraint {
            contentView.removeConstraints(leadingTrailing)
        }
        if let topBottom = topBottomConstraint {
            contentView.removeConstraints(topBottom)
        }
        addCustomViewConstraintWith(horizontalOffset: horizontalOffset, verticalOffset: verticalOffset)
    }
    
    fileprivate func addCustomViewConstraintWith(horizontalOffset: CGFloat, verticalOffset: CGFloat) {
        
        if let tempView = customView {
            let leadingTrailing = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(horizontalOffset)-[view]-\(horizontalOffset)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tempView])
            contentView.addConstraints(leadingTrailing)
            leadingTrailingConstraint = leadingTrailing
            
            let topBottom = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(verticalOffset)-[view]-\(verticalOffset)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tempView])
            contentView.addConstraints(topBottom)
            topBottomConstraint = topBottom
        }
    }
}

