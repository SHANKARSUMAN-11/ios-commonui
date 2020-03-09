//
//  CustomThumbView.swift
//  CustomSwitch
//
//  Created by Aleksandar Atanackovic on 12/20/16.
//  Copyright © 2016 Ivan Kovacevic. All rights reserved.
//

import UIKit

public class CustomThumbView: UIView {
    
    public var thumbImageView = UIImageView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.thumbImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.thumbImageView)
        
    }

    
}

extension CustomThumbView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.thumbImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.thumbImageView.layer.cornerRadius = self.layer.cornerRadius
        self.thumbImageView.clipsToBounds = self.clipsToBounds
        

    }
    
}
