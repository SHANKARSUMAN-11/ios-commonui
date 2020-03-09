//
//  BaseTableViewCell.swift
//  CommonUIKit
//
//  Created by Mayur Kothawade on 22/01/17.
//  Copyright © 2017 Coviam. All rights reserved.
//

import UIKit

@objc public class BaseTableViewCell: UITableViewCell {
    
    public var customView : UIView?
    public var recentTouch : UITouch?
    public var leadingTrailingConstraint : [NSLayoutConstraint]?
    public var topBottomConstraint : [NSLayoutConstraint]?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initializeCustomView(identifier: reuseIdentifier)
    }
    
    public init(style: UITableViewCell.CellStyle, customViewReuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: customViewReuseIdentifier)
        
        self.initializeCustomView(identifier: customViewReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        if let customViewForCell = customView as? BM_CellContentViewProtocol {
            customViewForCell.prepareForReuse()
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            self.recentTouch = touch
        }
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
    
    public func setCard(leading: CGFloat, trailing: CGFloat,bottom: CGFloat,top: CGFloat, contentViewBackgroundColor: UIColor = UIColor.groupTableViewBackground) {
        contentView.backgroundColor = contentViewBackgroundColor
        if let leadingTrailing = leadingTrailingConstraint {
            contentView.removeConstraints(leadingTrailing)
        }
        if let topBottom = topBottomConstraint {
            contentView.removeConstraints(topBottom)
        }
        addCustomViewConstraintWith(leading: leading, trailing: trailing,bottom: bottom,top: top)
    }
    
    fileprivate func addCustomViewConstraintWith(leading: CGFloat, trailing: CGFloat,bottom: CGFloat,top: CGFloat) {
        
        if let tempView = customView {
            let leadingTrailing = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(leading)-[view]-\(trailing)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tempView])
            contentView.addConstraints(leadingTrailing)
            leadingTrailingConstraint = leadingTrailing
            
            let topBottom = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(top)-[view]-\(bottom)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tempView])
            contentView.addConstraints(topBottom)
            topBottomConstraint = topBottom
        }
    }

    
    fileprivate func initializeCustomView(identifier:String?) {
        guard let identifier = identifier else {
            print("You just passed nil identifier while registering BaseTableViewCell")
            return
        }
        guard let view = UtilityMethods.getView(with: identifier) else {
            print("View class \(identifier) not found (Check Target membership)")
            return
        }
        self.addSubViewToContentView(tempView: view)
    }
    
    fileprivate func addSubViewToContentView(tempView:UIView) {
        customView = tempView
        contentView.addSubview(tempView)
        customView?.translatesAutoresizingMaskIntoConstraints = false
        addCustomViewConstraintWith(horizontalOffset: 0.0, verticalOffset: 0.0)
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

protocol BM_CellContentViewProtocol {
    func prepareForReuse()
}
