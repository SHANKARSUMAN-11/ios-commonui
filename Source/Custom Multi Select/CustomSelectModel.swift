//
//  CustomSelectModel.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 24/04/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public class CustomSelectModel {
    public var text: String?
    public var attributedText: NSAttributedString?
    public var selectionMode: SelectMode
    public var horizontalAlignment: Position
    public var verticalAlignment: Position
    public var isEnabled = true
    public var selectType: SelectType
    
    public init(withText text: String?, attributedText: NSAttributedString? = nil, selectType: SelectType = .single, selectionMode: SelectMode = .unselected, horizontalAlignment: Position = .left, verticalAlignment: Position = .center, isEnabled: Bool = true) {
        self.text = text
        self.attributedText = attributedText
        self.selectType = selectType
        self.selectionMode = selectionMode
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.isEnabled = isEnabled
    }
}
