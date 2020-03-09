//
//  CustomCell.swift
//  CommonUIKit
//
//  Created by Rajadorai DS on 12/06/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public enum verticalPosition: Int{
    case top = 0
    case center
    case bottom
}

public protocol CustomCellDelegate: class {
    func didTapCustomCell(sender: CustomCell)
}

public extension CustomCellDelegate {
    func didTapCustomCell(sender: CustomCell) {}
}

public class CustomCell: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    public var indexPath: IndexPath? = nil
    
    
    public weak var delegate: CustomCellDelegate? = nil
    
    public var titleText: String? = nil {
        didSet {
            self.title.text = titleText
        }
            }
    
    public var detailText: String? = nil {
        didSet {
            self.detail.text = detailText
        }
    }
    
    public var imageVerticalAlignment: verticalPosition = .center {
        didSet {
            self.configurePosition()
        }
    }
    
    public var buttonVerticalAlignment: verticalPosition = .center {
        didSet {
            self.configurePosition()
        }
    }
    
    public var listImage: String? = nil {
        didSet{
            let image = UIImage().getImage(named: listImage ?? "")
            self.imageView.image = image
            configurePosition()
        }
    }
    
    public var buttonImage: String? = nil {
        didSet {
            if let buttonImg = buttonImage, let image = UIImage(named: buttonImg) {
                self.button.setImage(image, for: .normal)
            }
            configurePosition()
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
        let nib = UINib(nibName: "CustomCell", bundle: bundle)
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
        self.setFont(titleFont: UIFont(name: "Effra-Bold", size: 18.0), detailFont: UIFont(name: "EffraMedium-Regular", size: 14.0))
        configurePosition()
    }
    
    func configureView() {
        title.textColor = textColor
        detail.textColor = textColor
    }
    
    
    
    public func configurePosition() {
        
         imageView.invalidateIntrinsicContentSize()
         button.invalidateIntrinsicContentSize()
        
        if imageView.image == nil {
            imageView.isHidden = true
            let leadingTitle = NSLayoutConstraint(item: title, attribute: .leading , relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
            NSLayoutConstraint.activate([leadingTitle])
        } else {
            imageView.isHidden = false
        }
        
        if detail.text == nil {
            let title = NSLayoutConstraint(item: view, attribute: .centerY , relatedBy: .equal, toItem: self.title, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([title])
            detail.isHidden = true
        } else {
            let title = NSLayoutConstraint(item: view, attribute: .centerY , relatedBy: .equal, toItem: self.title, attribute: .centerY, multiplier: 1, constant: 0)
            let detail = NSLayoutConstraint(item: self.detail, attribute: .bottom , relatedBy: .greaterThanOrEqual, toItem: view, attribute: .bottom, multiplier: 1, constant: 5)
            
            NSLayoutConstraint.activate([title,detail])
            self.detail.isHidden = false
        }

        switch imageVerticalAlignment {
        case .top:
            let image = NSLayoutConstraint(item: imageView, attribute: .centerY , relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 8)
            NSLayoutConstraint.activate([image])
        case .center:
            let image = NSLayoutConstraint(item: imageView, attribute: .centerY , relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([image])
            break
        case .bottom:
            let image = NSLayoutConstraint(item: imageView, attribute: .centerY , relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -8)
            NSLayoutConstraint.activate([image])
        }
        
        switch buttonVerticalAlignment {
        case .top:
            let button = NSLayoutConstraint(item: self.button, attribute: .centerY , relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 8)
            NSLayoutConstraint.activate([button])
        case .center:
            let button = NSLayoutConstraint(item: self.button, attribute: .centerY , relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([button])
            break
        case .bottom:
            let button = NSLayoutConstraint(item: self.button, attribute: .centerY , relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -8)
            NSLayoutConstraint.activate([button])
        }
        
    }
    
    
    public func setFont(titleFont tFont: UIFont?, detailFont dFont: UIFont?) {
        title.font = tFont
        detail.font = dFont
    }
    
    @IBAction func didTapCustomListButton(_ sender: Any) {
        delegate?.didTapCustomCell(sender: self)
    }
    
    
}
