//
//  PagerViewConfig.swift
//  CommonUIKit
//
//  Created by RONAK GARG on 30/05/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public class PagerViewConfig: NSObject {
    
    public var decelerationDistance: UInt = 0
    public var removesInfiniteLoopForSingleItem: Bool = false
    public var automaticSlidingInterval: CGFloat = 0.0
    public var isInfiniteScrolling: Bool = true
    public var itemSize: CGSize = .zero
    public var interitemSpacing: CGFloat = 8
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    public var horizontalInset: CGFloat = 0
    public var verticalInset: CGFloat = 0
    public var leadingSpace: CGFloat?
}
