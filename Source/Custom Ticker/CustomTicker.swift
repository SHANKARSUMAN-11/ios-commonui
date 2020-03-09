//
//  CustomTicker.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 19/03/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public protocol CustomTickerDelegate: class {
    func didTapRightButton(sender: Any)
    func didTapLeftButton(sender: Any)
}

public extension CustomTickerDelegate {
    func didTapRightButton(sender: Any) {}
    func didTapLeftButton(sender: Any) {}
}

public enum TickerType: Int, Codable {
    case plain = 0
    case info
    case success
    case warning
    case error
}

@available(*, deprecated, message: "Please use `CustomTickerNew` class instead. This class will be deprecated soon")
open class CustomTicker: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet public weak var leftButton: UIButton!
    @IBOutlet public weak var leftButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var leftButtonLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet public weak var rightButton: UIButton!
    @IBOutlet public weak var rightButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var rightButtonTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet public weak var descriptionLabel: UILabel!
    
    public weak var delegate: CustomTickerDelegate? = nil
    
    public var tickerType = TickerType(rawValue: 0)! {
        didSet {
            setupTicker()
        }
    }
    
    ///Sets the ticker title label text. Use this to set the text, text color, font etc
    public var titleText: NSAttributedString? = nil {
        didSet {
            self.titleLabel.attributedText = titleText
        }
    }
    
    ///Sets the ticker description label text. Use this to set the text, text color, font etc
    public var descriptionText: NSAttributedString? = nil {
        didSet {
            self.descriptionLabel.attributedText = descriptionText
        }
    }
    
    var component: Component.Ticker? = nil
    
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
        let nib = UINib(nibName: "CustomTicker", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        
        setupTicker()
    }
    
    func setupTicker() {
        
        component = Configuration.shared.getComponent()?.Ticker
        let tickerType_ = getTypeConfig(for: self.tickerType.rawValue)
        
        self.layer.backgroundColor = tickerType_?.getBackgroundColor().cgColor
        self.layer.borderColor = tickerType_?.getBorderColor().cgColor
        self.layer.borderWidth = component?.borderWidth ?? kDefaultBorderWidth
        self.layer.cornerRadius = component?.cornerRadius ?? kDefaultCornerRadius
        self.titleLabel.textColor = tickerType_?.getTextColor()
        self.descriptionLabel.textColor = tickerType_?.getTextColor()
        
        self.setTitleFont(withFont: UIFont(name: "EffraMedium-Regular", size: 16.0))
        self.setDescriptionFont(withFont: UIFont(name: "Effra-Regular", size: 16.0))
        
        self.setLeftButtonImage(withImageName: nil)
        self.setRightButtonImage(withImageName: nil)
        
        setButtonPosition(position: .top)
    }
    
    func getTypeConfig(for state: Int) -> Component.Ticker.TickerTypes? {
        return component?.types?.filter({ $0.tickerType == state }).first
    }
    
    public func setLeftButtonImage(withImageName name: String?, imageColor: UIColor? = nil) {
        
        if let image = UIImage().getImage(named: name) {
            leftButton.setImage(image, for: .normal)
            leftButtonLeadingConstraint.constant = 16.0
            leftButtonWidth.constant = 24.0
            
        } else {
            leftButtonLeadingConstraint.constant = 0.0
            leftButtonWidth.constant = 0.0
        }
        
        if let imageColor = imageColor {
            leftButton.tintColor = imageColor
        }
    }
    
    public func setRightButtonImage(withImageName name: String?, imageColor: UIColor? = nil) {
        
        if let image = UIImage().getImage(named: name) {
            rightButton.setImage(image, for: .normal)
            rightButtonTrailingConstraint.constant = 16.0
            rightButtonWidth.constant = 24.0
            
        } else {
            rightButtonTrailingConstraint.constant = 0.0
            rightButtonWidth.constant = 0.0
        }
        
        if let imageColor = imageColor {
            rightButton.tintColor = imageColor
        }
    }
    
    public func setButtonPosition(position: Position? = .top) {
        
        switch position {
        case .center?:
            let yLeft = NSLayoutConstraint(item: leftButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            let yRight = NSLayoutConstraint(item: rightButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([yLeft, yRight])
            
        case .bottom?:
            let yLeft = NSLayoutConstraint(item: leftButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -20)
            let yRight = NSLayoutConstraint(item: rightButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -20)
            
            NSLayoutConstraint.activate([yLeft, yRight])
            
        default:
            let yLeft = NSLayoutConstraint(item: leftButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20)
            let yRight = NSLayoutConstraint(item: rightButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20)
            
            NSLayoutConstraint.activate([yLeft, yRight])
        }
    }
    
    public func setTitle(title: String?) {
        titleLabel.text = title
    }
    
    public func setDescription(description: String?) {
        descriptionLabel.text = description
    }
    
    public func setBackgoundColor(color: UIColor?) {
        self.layer.backgroundColor = color?.cgColor
    }
        
    //MARK:- Set Fonts
    
    public func setFont(withFont font: UIFont) {
        titleLabel.font = font
        descriptionLabel.font = font
    }
    
    public func setTitleFont(withFont font: UIFont?) {
        titleLabel.font = font
    }
    
    public func setDescriptionFont(withFont font: UIFont?) {
        descriptionLabel.font = font
    }
    
    
    //MARK:- Actions
    
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        delegate?.didTapLeftButton(sender: self)
    }
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        delegate?.didTapRightButton(sender: self)
    }
}
