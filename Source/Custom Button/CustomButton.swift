//
//  CustomButton.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 06/03/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import Foundation
import UIKit

public protocol CustomButtonDelegate: class {
    func didTapButton(sender: Any)
}

public extension CustomButtonDelegate {
    func didTapButton(sender: Any) {}
}

public enum Type: Int, Codable {
    case contained = 0
    case outlined
    case ghost
    case disabled
}

public class CustomButton: UIButton {
    
    public var type: Int = 0 {
        didSet {
            setConfiguration()
        }
    }
    var component: Component.Button? = nil
    public weak var delegate: CustomButtonDelegate? = nil
    
    @IBInspectable var tagValue: Int {
        set(newValue) {
            tag = newValue
        }
        get {
            return tag
        }
    }
    
    @IBInspectable var shapeType: Int {
        set(newValue) {
            type = min(newValue, 2)
        }
        get {
            return type
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var backgroundColor_: UIColor = .clear {
        didSet {
            self.layer.backgroundColor = self.backgroundColor_.cgColor
        }
    }
    
    @IBInspectable
    public var textColor_: UIColor = .clear {
        didSet {
            self.setTitleColor(self.textColor_, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfiguration()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setConfiguration()
    }
    
    func setConfiguration() {
        component = Configuration.shared.getComponent()?.Button
        let buttonType = getStateConfig(for: self.type)
                
        self.layer.borderColor = buttonType?.getBorderColor().cgColor
        self.layer.borderWidth = component?.borderWidth ?? 0.0
        self.layer.backgroundColor = buttonType?.getBackgroundColor().cgColor
        self.layer.cornerRadius = component?.cornerRadius ?? kDefaultCornerRadius
        self.setTitleColor(buttonType?.getTintColor(), for: .normal)
        self.tintColor = buttonType?.getTintColor()
        self.setFont(withFont: UIFont(name: "EffraMedium-Regular", size: 16.0))
        self.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
        if self.type == Type.disabled.rawValue {
            self.isUserInteractionEnabled = false
        } else {
            self.isUserInteractionEnabled = true
        }
        
        self.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
    }
    
    public func setButton(withTitle title: String? = nil, titleColor: UIColor? = nil, image: UIImage? = nil, type: Type? = .contained) {
        self.type = type?.rawValue ?? 0
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        
        if titleColor != nil {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    
    public func setFont(withFont font: UIFont?) {
        self.titleLabel?.font = font
    }
    
    func getStateConfig(for state: Int) -> Component.Button.Types? {
        return component?.types?.filter({ $0.buttonType == state }).first
    }
    
    @objc func didTapButton(sender: Any) {
        delegate?.didTapButton(sender: self)
    }
}
