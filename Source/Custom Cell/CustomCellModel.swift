//
//  CustomListCellModel.swift
//  CommonUIKit
//
//  Created by Rajadorai DS on 17/06/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public class CustomCellModel {
    public var title: String?
    public var detail: String?
    public var listImage: String?
    public var buttonImage: String?
    public var imageVerticalAlignment: verticalPosition
    public var buttonVerticalAlignment: verticalPosition

    public init(withTitle title: String?, withDetail detail: String? = nil, listImage: String? = nil,buttonImage: String? = nil,imageVerticalAlignment: verticalPosition = .center, buttonVerticalAlignment: verticalPosition = .center ) {
    self.title = title
    self.detail = detail
    self.listImage = listImage
    self.buttonImage = buttonImage
    self.imageVerticalAlignment = imageVerticalAlignment
    self.buttonVerticalAlignment = buttonVerticalAlignment
    }
}
