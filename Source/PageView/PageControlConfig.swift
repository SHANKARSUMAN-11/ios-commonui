//
//  PageControlConfig.swift
//  CommonPagerView
//
//  Created by RONAK GARG on 29/05/19.
//  Copyright © 2019 Ronak garg. All rights reserved.
//

import UIKit

public class PageControlConfig: NSObject {

    public var itemSpacing: CGFloat = 7.0
    public var interitemSpacing: CGFloat = 7.0
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    public var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .left
    public var hidesForSinglePage: Bool = true
    public var fillColorForNormal: UIColor = UIColor.white.withAlphaComponent(0.64)
    public var fillColorForSelected: UIColor = .white
    public var style: PageControl.PageControlStyle = .round
    public var shouldShowPageControl: Bool = true
    
}
