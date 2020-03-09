//
//  CustomBubble.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 14/03/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

open class CustomBubble: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var leftButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var leftButtonLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet public weak var leftSeparator: UIView!
    @IBOutlet public weak var leftSeparatorWidth: NSLayoutConstraint!
    
    @IBOutlet weak var mainButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var rightButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var rightButtonTrailingConstraint: NSLayoutConstraint!
    
    public var leftButtonAction: ((UIButton) -> Void)?
    public var rightButtonAction: ((UIButton) -> Void)?
    public var mainButtonAction: ((UIButton) -> Void)?
    
    @IBInspectable
    public var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable
    public var cornerRadius_: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius_
        }
    }
    
    public var mainButtonLines: Int = 0 {
        didSet {
            self.mainButton.titleLabel?.numberOfLines = 0
        }
    }
    
    @IBInspectable
    public var textColor: UIColor = .clear {
        didSet {
            self.mainButton.setTitleColor(textColor, for: .normal)
        }
    }
    
    @IBInspectable
    public var selectedTextColor: UIColor = .clear {
        didSet {
            self.mainButton.setTitleColor(textColor, for: .selected)
        }
    }
    
    @IBInspectable
    public var shadowWidth: Int = 0 {
        didSet {
            //self.helperLabel.textColor = self.helperLabelTextColor
        }
    }
    
    @IBInspectable
    public var backgroundColor_: UIColor = .clear {
        didSet {
            self.layer.backgroundColor = self.backgroundColor_.cgColor
        }
    }
    
    public var leftButtonAttributedTitle: NSMutableAttributedString? = nil {
        didSet {
            UIView.performWithoutAnimation {
                self.leftButton.setAttributedTitle(leftButtonAttributedTitle, for: .normal)
                self.leftButtonLeadingConstraint.constant = 7.0
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.leftButtonWidth.constant = 30.0
                } else {
                    self.leftButtonWidth.constant = 20.0
                }
            }
        }
    }
    
    public var leftButtonTitle: String? = nil {
        didSet {
            UIView.performWithoutAnimation {
                self.leftButton.setTitle(leftButtonTitle, for: .normal)
                self.leftButtonLeadingConstraint.constant = 7.0
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.leftButtonWidth.constant = 30.0
                } else {
                    self.leftButtonWidth.constant = 20.0
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomBubble", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        
        let component = Configuration.shared.getComponent()?.Bubble
        self.layer.backgroundColor = component?.getBackgroundColor().cgColor
        self.layer.borderColor = component?.getBorderColor().cgColor
        self.layer.borderWidth = component?.borderWidth ?? kDefaultBorderWidth
        self.layer.cornerRadius = component?.cornerRadius ?? kDefaultCornerRadius
        self.mainButton.setTitleColor(component?.getTextColor(), for: .normal)
        self.mainButton.setTitleColor(component?.getSelectedTextColor(), for: .selected)
        self.setFont(withFont: UIFont(name: "Effra-Regular", size: 16.0))
        
        self.setLeftButtonImage(withImageName: nil)
        self.setRightButtonImage(withImageName: nil)
    }
    
    public func setFont(withFont font: UIFont?) {
        self.mainButton.titleLabel?.font = font
        self.leftButton.titleLabel?.font = font
    }
    
    public func setLeftButtonImage(withImageName image: UIImage?, imageColor: UIColor? = nil) {
        
        if image == nil {
            leftButtonLeadingConstraint.constant = 0.0
            leftButtonWidth.constant = 0.0
        } else {
            leftButton.setImage(image, for: .normal)
            leftButtonLeadingConstraint.constant = 16.0
            leftButtonWidth.constant = 16.0
        }
        
        if let imageColor = imageColor {
            leftButton.tintColor = imageColor
        }
    }
    
    public func setRightButtonImage(withImageName image: UIImage?, imageColor: UIColor? = nil) {
        
        if image == nil {
            rightButtonTrailingConstraint.constant = 0.0
            rightButtonWidth.constant = 0.0
        } else {
            rightButton.setImage(image, for: .normal)
            rightButtonTrailingConstraint.constant = 16.0
            rightButtonWidth.constant = 16.0
        }
        
        if let imageColor = imageColor {
            rightButton.tintColor = imageColor
        }
    }
    
    public func setMainButtonAttributedTitle(_ title: NSMutableAttributedString) {
        UIView.performWithoutAnimation {
            self.mainButton.setAttributedTitle(title, for: .normal)
        }
    }
    
    public func setMainButtonTitle(_ title: String, titleColor: UIColor? = nil) {
        UIView.performWithoutAnimation {
            self.mainButton.setTitle(title, for: .normal)
            self.mainButton.setTitleColor(titleColor, for: .normal)
        }
    }
    
    public func setBackgroundColor(color: UIColor?) {
        self.layer.backgroundColor = color?.cgColor
    }
    
    public func setBorderWidth(width: CGFloat) {
        self.layer.borderWidth = width
    }
    
    public func setBorderColor(color: UIColor?) {
        self.layer.borderColor = color?.cgColor
    }
    
    //MARK:- Actions
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        leftButtonAction?(sender)
    }
    
    @IBAction func didTapMainButton(_ sender: UIButton) {
        mainButtonAction?(sender)
    }
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        rightButtonAction?(sender)
    }
}
