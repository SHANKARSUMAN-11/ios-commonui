//
//  InsetLabel.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 20/06/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public class InsetLabel: UILabel {
    
    public var edgeInset = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        let insetRect = bounds.inset(by: edgeInset)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -edgeInset.top,
                                          left: -edgeInset.left,
                                          bottom: -edgeInset.bottom,
                                          right: -edgeInset.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInset))
    }
    
}

extension InsetLabel {
    @IBInspectable
    var leftEdgeInset: CGFloat {
        set { edgeInset.left = newValue }
        get { return edgeInset.left }
    }
    
    @IBInspectable
    var rightEdgeInset: CGFloat {
        set { edgeInset.right = newValue }
        get { return edgeInset.right }
    }
    
    @IBInspectable
    var topEdgeInset: CGFloat {
        set { edgeInset.top = newValue }
        get { return edgeInset.top }
    }
    
    @IBInspectable
    var bottomEdgeInset: CGFloat {
        set { edgeInset.bottom = newValue }
        get { return edgeInset.bottom }
    }
}

