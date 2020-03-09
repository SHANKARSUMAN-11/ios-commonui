//
//  CustomWalkthroughView.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 23/02/20.
//  Copyright © 2020 Coviam. All rights reserved.
//

import UIKit

class CustomWalkthroughView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet public weak var masterView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightButton: CustomButton!
    @IBOutlet weak var leftButton: CustomButton!
    @IBOutlet weak var countLabel: UILabel!
    
    public var imageView: UIView?
    
    public var rightButtonAction: ((UIButton) -> Void)?
    public var leftButtonAction: ((UIButton) -> Void)?
    
    private var builder: WalkthroughBuilder? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib(frame: nil)
    }
    
    private func loadViewFromNib(frame: CGRect?) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomWalkthroughView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        
        if let frame_ = frame {
            view.frame = frame_
        }
        
        view.fixInView(self)
        addSubview(view)
    }
    
    func setupView(with builder: WalkthroughBuilder?) {
        
        self.builder = builder
                        
        setupActionButtons()
                
        setupWalkthroughText()
        
        setupWalkthroughView()
        
        setupCountLabel()
        
    }
    
    //MARK:- Button Action methods
    
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        self.leftButtonAction?(sender)
    }
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        self.rightButtonAction?(sender)
    }
    
    
    //MARK:- Private Methods
    
    fileprivate func setupActionButtons() {
        
        leftButton.type = builder?.leftButtonType?.rawValue ?? Type.outlined.rawValue
        rightButton.type = builder?.rightButtonType?.rawValue ?? Type.outlined.rawValue
        
        if leftButton.type != Type.ghost.rawValue {
            leftButton.cornerRadius = builder?.buttonCornerRadius ?? 16.0
            leftButton.borderWidth = builder?.buttonBorderWidth ?? 2.0
            leftButton.borderColor = builder?.buttonBorderColor ?? UIColor.white
        } else {
            leftButton.borderWidth = 0.0
        }
        
        if rightButton.type != Type.ghost.rawValue {
            rightButton.cornerRadius = builder?.buttonCornerRadius ?? 16.0
            rightButton.borderWidth = builder?.buttonBorderWidth ?? 2.0
            rightButton.borderColor = builder?.buttonBorderColor ?? UIColor.white
        } else {
            rightButton.borderWidth = 0.0
        }
                
        if let title = builder?.rightButtonTitle {
            rightButton.isHidden = false
            rightButton.setAttributedTitle(title, for: .normal)
        } else {
            rightButton.isHidden = true
        }
        
        if let title = builder?.leftButtonTitle {
            leftButton.isHidden = false
            leftButton.setAttributedTitle(title, for: .normal)
        } else {
            leftButton.isHidden = true
        }
    }
    
    fileprivate func setupWalkthroughText() {
        titleLabel.attributedText = builder?.title
        
        if let alignment = builder?.textAlignment {
            titleLabel.textAlignment = (alignment == Position.right) ? NSTextAlignment.right : NSTextAlignment.left
        }
    }
    
    fileprivate func setupWalkthroughView() {
        if let view_ = builder?.view {
            
            imageView = view_
            
            if let startingPoint = builder?.viewStartingPoint, let imageView = imageView {
                
                imageView.frame = CGRect(x: startingPoint.x, y: startingPoint.y, width: imageView.frame.size.width, height: imageView.frame.size.height)
                view.addSubview(imageView)
                
                if builder?.verticalAlignment == WalkthroughTextAlignment.imageAtTop {
                    NSLayoutConstraint(item: masterView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imageView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0).isActive = true
                    
                } else {
                    NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: masterView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0).isActive = true
                }
            }
        }
    }
    
    fileprivate func setupCountLabel() {
        countLabel.attributedText = builder?.onboardingCount
    }
}
