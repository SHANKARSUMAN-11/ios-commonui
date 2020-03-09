//
//  CommonWalkthroughPageControl.swift
//  CommonWalkthrough
//
//  Created by Rahul Pengoria on 13/03/19.
//  Copyright © 2019 com.walkthrough.pengoria. All rights reserved.
//

import UIKit

/// Page control costomization
public class CommonWalkthroughPageControl: NSObject {
    
    /// Postion of page control(bottom,middle,top)
    var position: WalkthroughPosition = .bottom
    
    /// page control tint color
    var pageIndicatorTintColor: UIColor = .groupTableViewBackground
    
    /// page control currnt indicator tint color
    var currentPageIndicatorTintColor: UIColor = .red
    
    /// Returns an affine transformation matrix constructed from scaling values you provide.
    var transform: CGAffineTransform = CGAffineTransform(scaleX: 1, y: 1)
    
    /// yoffset from postion
    var yOffset: CGFloat = 0.0
    
    var selectedPageControl: Int = 0
}
