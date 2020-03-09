//
//  BaseCollectionReusableView.swift
//  BlibliMobile-iOS
//
//  Created by Steven Yonanta Siswanto on 5/24/17.
//  Copyright © 2017 Coviam, PT. All rights reserved.
//

import UIKit

public class BaseCollectionReusableView: UICollectionReusableView {
    public var customView : UIView?
    
    public static func dequequeReusableView(forCollectionView collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, reuseIdentifier: String, indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
        if  let bmCell = cell as? BaseCollectionReusableView,
            bmCell.customView == nil {
            bmCell.initializeCustomView(identifier: reuseIdentifier)
        }
        return cell
    }
    
    internal func initializeCustomView(identifier: String?){
        guard let id = identifier else {
            print("You just passed nil identifier while registering BM_BaseTableViewCell")
            return
        }
        if let tempView = (Bundle.main.loadNibNamed(id, owner: self, options: nil)?[0] as? UIView) {
            customView = tempView
            addSubview(tempView)
            tempView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            print("Are you sure \(id) class exists in your project? ( Check Target membership once )")
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let customView = self.customView else {
            return
        }
        
        let views = ["view": customView]
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)
    }
}

