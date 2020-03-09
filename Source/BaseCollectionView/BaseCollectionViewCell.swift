//
//  BaseCollectionViewCell.swift
//  BlibliMobile-iOS
//
//  Created by Steven Yonanta Siswanto on 2/22/17.
//  Copyright © 2017 Coviam, PT. All rights reserved.
//

import UIKit

public class BaseCollectionViewCell: UICollectionViewCell {
    public var customView : UIView?
    public var recentTouch : UITouch?
    
    private(set) var selectedColor: UIColor?
    private(set) var normalColor: UIColor?
    public var leadingTrailingConstraint : [NSLayoutConstraint]?
    public var topBottomConstraint : [NSLayoutConstraint]?
    
    override public var isSelected: Bool {
        didSet {
            guard let customView = self.customView,
                let normal = normalColor,
                let selected = selectedColor else {
                    return
            }
            customView.backgroundColor = isSelected ? selected : normal
        }
    }
    
    public func setCustomViewBackgroundColor(forNormalState normal: UIColor, selectedState selected: UIColor) {
        normalColor = normal
        selectedColor = selected
    }
    
    public static func dequeueReusableCell(for collectionView: UICollectionView,with reuseIdentifier: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if  let bmCell = cell as? BaseCollectionViewCell {
            bmCell.initializeCustomView(identifier: reuseIdentifier)
        }
        return cell
    }
    
    internal func initializeCustomView(identifier: String){
        guard let tempView = UtilityMethods.getView(with: identifier) else {
            return
        }
        customView?.removeFromSuperview()
        customView = tempView
        contentView.addSubview(tempView)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(horizontalOffset: 0.0, verticalOffset: 0.0)
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
        addConstraints(horizontalOffset: horizontalOffset, verticalOffset: verticalOffset)
    }
    
    fileprivate func addConstraints(horizontalOffset: CGFloat, verticalOffset: CGFloat) {
        
        guard let tempView = customView else {
            return
        }
        let leadingTrailingMetrics = ["hOffset": horizontalOffset]
        let leadingTrailing = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hOffset)-[view]-(hOffset)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: leadingTrailingMetrics, views: ["view":tempView])
        NSLayoutConstraint.activate(leadingTrailing)
        leadingTrailingConstraint = leadingTrailing
        
        let topBottomMetrics = ["vOffset": verticalOffset]
        let topBottom = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vOffset)-[view]-(vOffset)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: topBottomMetrics, views: ["view":tempView])
        NSLayoutConstraint.activate(topBottom)
        topBottomConstraint = topBottom
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

}
