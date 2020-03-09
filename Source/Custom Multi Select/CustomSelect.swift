//
//  CustomSelect.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 23/04/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public enum SelectMode: Int {
    case unselected = 0
    case selected
    case intermediate
}

public enum SelectType: Int {
    case single = 0
    case multiple
}

public protocol CustomSelectDelegate: class {
    func didTapCustomSelect(sender: CustomSelect)
}

public extension CustomSelectDelegate {
    func didTapCustomSelect(sender: CustomSelect) {}
}

public class CustomSelect: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var label: UILabel!
    @IBOutlet public weak var button: UIButton!

    
    public var indexPath: IndexPath? = nil
    
    public weak var delegate: CustomSelectDelegate? = nil
    
    @IBInspectable
    public var imageTintColor: UIColor? = UIColor(hexString: kDefaultThemeColor) {
        didSet {
            self.configureView()
        }
    }
    
    @IBInspectable
    public var selectedImageTintColor: UIColor? = UIColor(hexString: kDefaultThemeColor) {
        didSet {
            self.configureView()
        }
    }
    
    public var text: String? = nil {
        didSet {
            self.label.text = text
        }
    }
    
    public var attributedText: NSAttributedString? = nil {
        didSet {
            if attributedText != nil {
                self.label.attributedText = attributedText
            }
        }
    }
    
    @IBInspectable public var isEnabled: Bool = true {
        didSet {
            self.configureView()
        }
    }
    
    @IBInspectable
    public var textColor: UIColor? = UIColor(hexString: kDefaultTextColor).withAlphaComponent(0.6) {
        didSet {
            self.configureView()
        }
    }
    
    @IBInspectable
    var selectedTextColor: UIColor? = UIColor(hexString: kDefaultSelectedTextColor) {
        didSet {
            self.configureView()
        }
    }
    
    public var selectType: SelectType = .single {
        didSet {
            self.configureView()
        }
    }
    
    public var selectionMode: SelectMode = .unselected {
        didSet {
            self.configureView()
        }
    }
    
    public var verticalAlignment: Position = .center {
        didSet {
            self.configurePosition()
        }
    }
    
    public var horizontalAlignment: Position = .left {
        didSet {
            self.configurePosition()
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
        let nib = UINib(nibName: "CustomSelect", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        
        let component = Configuration.shared.getComponent()?.MultiSelect
        self.layer.backgroundColor = component?.getBackgroundColor().cgColor
        self.layer.borderColor = component?.getBorderColor().cgColor
        self.layer.borderWidth = component?.borderWidth ?? kDefaultBorderWidth
        self.layer.cornerRadius = component?.cornerRadius ?? kDefaultCornerRadius
        
        self.textColor = component?.getTextColor()
        self.selectedTextColor = component?.getSelectedTextColor()
        self.imageTintColor = component?.getImageTintColor()
        self.selectedImageTintColor = component?.getSelectedImageTintColor()
        
        self.setFont(withFont: UIFont(name: "Effra-Regular", size: 16.0))
        configurePosition()
    }
    
    /*
    public override init(withType type: SelectType) {
        super.init()
        self.selectType = type
    }
    */
    
    func configureView() {
        configureUserInteraction()
        configureImage()
        configurePosition()
    }
    
    func configureImage() {
        setImage(withImage: getImage(), tintColor: imageTintColor)
    }
    
    func configureUserInteraction() {
        
        if !isEnabled {
            button.isEnabled = false
            imageView.tintColor = .gray
            label.textColor = textColor?.withAlphaComponent(0.38)
        } else {
            button.isEnabled = true
            
            switch selectionMode {
            case .intermediate, .selected:
                label.textColor = selectedTextColor
                imageView.tintColor = selectedImageTintColor
            default:
                label.textColor = textColor
                imageView.tintColor = imageTintColor
            }
        }
    }
    
    public func configurePosition() {
        
        imageView.invalidateIntrinsicContentSize()

        switch verticalAlignment {
        case .top:
            let image = NSLayoutConstraint(item: imageView, attribute: .top , relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([image])
        case .bottom:
            let image = NSLayoutConstraint(item: imageView, attribute: .bottom , relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([image])
        default:
            let image = NSLayoutConstraint(item: view, attribute: .centerY , relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([image])
        }
    }
    
    func getImage() -> UIImage? {
        
        switch selectType {
        case .multiple:
            return imageForMultiSelect()
        default:
            return imageForSingleSelect()
        }
    }
    
    func imageForMultiSelect() -> UIImage? {
        
        switch selectionMode {
        case .intermediate:
            return UIImage().getImage(named: "check_box_intermediate")
        case .selected:
            return UIImage().getImage(named: "check_box_selected")
        default:
            return UIImage().getImage(named: "check_box_unselected")
        }
    }
    
    func imageForSingleSelect() -> UIImage? {
        switch selectionMode {
        case .selected:
            return UIImage().getImage(named: "radio_button_selected")
        default:
            return UIImage().getImage(named: "radio_button_unselected")
        }
    }
    
    public func setImage(withImage image: UIImage?, tintColor: UIColor? = nil) {
    
        if let image = image {
            imageView.image = image
        } else {
            imageView.image = getImage()
        }
        
        if selectionMode == .selected || selectionMode == .selected {
            imageView.tintColor = selectedImageTintColor
        } else {
            imageView.tintColor = tintColor
        }
    }
    
    public func setFont(withFont font: UIFont?) {
        label.font = font
    }
    
    @IBAction func didTapCustomSelectButton(_ sender: UIButton) {
        delegate?.didTapCustomSelect(sender: self)
    }
}
