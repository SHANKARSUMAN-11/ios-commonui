//
//  EmptyStateBackgroundView.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 06/05/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public protocol EmptyStateBackgroundViewDelegate: class {
    func didTapButton(_ sender: UIButton, parent: Any)
}

public extension EmptyStateBackgroundViewDelegate {
    func didTapButton(_ sender: UIButton, parent: Any) {}
}

public class EmptyStateBackgroundView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet public weak var button: CustomButton!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageToTitleSpace: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    public var delegate: EmptyStateBackgroundViewDelegate? = nil
    
    public var didTapEmptyStateButton: ((EmptyStateBackgroundView) -> Void)?
    
    public var title: NSAttributedString? = nil {
        didSet {
            titleLabel.attributedText = title
        }
    }
    
    public var message: NSAttributedString? = nil {
        didSet {
            messageLabel.attributedText = message
        }
    }
    
    public var buttonTitle: NSAttributedString? = nil {
        didSet {
            if let title = buttonTitle {
                button.isHidden = false
                button.setAttributedTitle(title, for: .normal)
            } else {
                button.isHidden = true
            }
        }
    }
    
    public var backgroundColor_: UIColor = .white {
        didSet {
            self.backgroundColor = backgroundColor_
        }
    }
    
    public var buttonColor: UIColor = UIColor(hexString: "#0095DA") {
        didSet {
            button.backgroundColor_ = buttonColor
        }
    }
    
    public var image: UIImage? = nil {
        didSet {
            if let image_ = image {
                imageView.image = image_
            } else {
                imageViewHeight.constant = 0
                imageToTitleSpace.constant = 0
            }
        }
    }
    
    public var imageHeight: CGFloat = 235 {
        didSet {
            imageViewHeight.constant = imageHeight
        }
    }
    
    public var buttonheight: CGFloat = 40 {
        didSet {
            buttonHeight.constant = buttonheight
        }
    }
    
    public var buttonType: Int = 0 {
        didSet {
            button.type = buttonType
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
        let nib = UINib(nibName: "EmptyStateBackgroundView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        
        titleLabel.font = UIFont(name: "EffraMedium-Regular", size: 18.0)
        messageLabel.font = UIFont(name: "Effra-Regular", size: 16.0)
        messageLabel.textColor = UIColor.black.withAlphaComponent(0.38)
//        
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        messageLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        imageView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .vertical)
//        
        button.type = 0
    }
    
    public func setButtonType(withType type: Type) {
        button.type = type.rawValue
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        didTapEmptyStateButton?(self)
        delegate?.didTapButton(sender, parent: self)
    }
}
