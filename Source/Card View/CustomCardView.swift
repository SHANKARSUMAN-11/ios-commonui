//
//  CustomCardView,swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 12/06/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public class CustomCardView: UIView {
    
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet public weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerLabel: UILabel!
    
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet weak var logoImageWidth: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var infoBackgroundView: UIView!
    @IBOutlet public weak var infoImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoBackgroundViewLeading: NSLayoutConstraint!
    @IBOutlet weak var infoHeight_: NSLayoutConstraint!
    @IBOutlet weak var bannerHeight_: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundViewLeading: NSLayoutConstraint!
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
        let nib = UINib(nibName: "CustomCardView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        
        self.bannerImage = nil
        self.bannerText = nil
        self.infoImage = nil
        self.leftInset = 0.0
        self.logoWidth = 0.0
        self.infoText = nil
        
    }
    
    public var cornerRadius_: CGFloat = 0.0 {
        didSet {
            self.backgroundView.layer.cornerRadius = cornerRadius_
            self.backgroundView.layer.masksToBounds = true
            self.logoImageView.layer.cornerRadius = cornerRadius_
            self.logoImageView.layer.masksToBounds = true
        }
    }
    
    public var logoWidth: CGFloat = 0.0 {
        didSet {
            self.logoImageWidth.constant = logoWidth
        }
    }
    
    public var bannerImage: UIImage? = nil {
        didSet {
            if let bannerImage = bannerImage {
                bannerImageView.image = bannerImage
            } else {
                bannerImageView.image = nil
            }
        }
    }
    
    public var infoImage: UIImage? = nil {
        didSet {
            if let infoImage = infoImage {
                infoImageView.image = infoImage
            } else {
                infoImageView.image = nil
            }
        }
    }
    
    public var logoImage: UIImage? = nil {
        didSet {
            if let logoImage = logoImage {
                logoImageView.image = logoImage
                logoImageView.isHidden = false
            } else {
                logoImageView.image = nil
                logoImageView.isHidden = true
            }
        }
    }
    
    public var logoImageBorderWidth: CGFloat = 0.0 {
        didSet {
            logoImageView.layer.borderWidth = logoImageBorderWidth
        }
    }
    
    public var logoImageBorderColor: UIColor = .clear {
        didSet {
            logoImageView.layer.borderColor = logoImageBorderColor.cgColor
        }
    }
    
    public var leftInset: CGFloat = 0.0 {
        didSet {
            self.backgroundViewLeading.constant = leftInset
        }
    }
    
    public var bannerHeight: CGFloat = 0.0 {
        didSet {
            //bannerHeight_.constant = bannerHeight
        }
    }
    
    public var infoHeight: CGFloat = 0.0 {
        didSet {
            infoHeight_.constant = infoHeight
        }
    }
    
    public var bannerText: NSAttributedString? = nil {
        didSet {
            bannerLabel.attributedText = bannerText
        }
    }
    
    public var infoText: NSAttributedString? = nil {
        didSet {
            infoLabel.attributedText = infoText
        }
    }
}
