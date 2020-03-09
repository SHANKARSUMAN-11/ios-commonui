//
//  CustomTickerNew.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 01/03/20.
//  Copyright © 2020 Coviam. All rights reserved.
//

import UIKit

open class CustomTickerNew: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet public weak var leftButton: UIButton!
    @IBOutlet public weak var leftButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var leftButtonLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet public weak var rightButton: UIButton!
    @IBOutlet public weak var rightButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var rightButtonTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public weak var delegate: CustomTickerDelegate? = nil
    
    
    ///Use this variable to set the type of ticker. Take a look at `TickerType` enum for the possible cases
    public var tickerType = TickerType(rawValue: 0)! {
        didSet {
            setupTicker()
        }
    }
    
    
    ///The Left button's vertical position can be changed by using this property. The default is set to .top
    public var leftButtonPosition: Position = .top {
        didSet {
            setButtonPosition(for: leftButton, position: leftButtonPosition)
        }
    }
    
    
    ///The Right button's vertical position can be changed by using this property. The default is set to .top
    public var rightButtonPosition: Position = .top {
        didSet {
            setButtonPosition(for: rightButton, position: rightButtonPosition)
        }
    }
    
    ///Sets the ticker title label text. Use this to set the text, text color, font etc
    public var titleText: NSAttributedString? = nil {
        didSet {
            self.titleLabel.attributedText = titleText
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
        let nib = UINib(nibName: "CustomTickerNew", bundle: bundle)
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
        self.titleLabel.font = UIFont(name: "Effra-Regular", size: 16.0)
        
        self.setLeftButtonImage(withImageName: nil)
        self.setRightButtonImage(withImageName: nil)
        
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
    
    public func setBackgoundColor(color: UIColor?) {
        self.layer.backgroundColor = color?.cgColor
    }
    
    fileprivate func setButtonPosition(for button: UIButton, position: Position) {
        
        switch position {
        case .center:
            let y = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([y])
            
        case .bottom:
            let y = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([y])
            
        default:
            let y = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([y])
        }
    }
    
    //MARK:- Actions
    
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        delegate?.didTapLeftButton(sender: self)
    }
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        delegate?.didTapRightButton(sender: self)
    }
}
