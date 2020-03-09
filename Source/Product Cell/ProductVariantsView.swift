//
//  ProductVariantsView.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 29/05/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public class ProductVariantsView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var variant1: UIView!
    @IBOutlet weak var variant2: UIView!
    @IBOutlet weak var variant3: UIView!
    @IBOutlet weak var variantCount: UILabel!
    @IBOutlet weak var variant3Width: NSLayoutConstraint!
    @IBOutlet weak var variant2Width: NSLayoutConstraint!
    @IBOutlet weak var variant1Width: NSLayoutConstraint!
    
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
        let nib = UINib(nibName: "ProductVariantsView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        
        self.isHidden = true
        self.backgroundView.layer.cornerRadius = 12.0
        self.variant1.layer.cornerRadius = 6.0
        self.variant2.layer.cornerRadius = 6.0
        self.variant3.layer.cornerRadius = 6.0
        self.variant1.clipsToBounds = true
        self.variant2.clipsToBounds = true
        self.variant3.clipsToBounds = true
        
        self.variant1.layer.borderWidth = 1.0
        self.variant1.layer.borderColor = UIColor.white.cgColor
        self.variant2.layer.borderWidth = 1.0
        self.variant2.layer.borderColor = UIColor.white.cgColor
        self.variant3.layer.borderWidth = 1.0
        self.variant3.layer.borderColor = UIColor.white.cgColor
        
        self.variantCount.text = nil
        
        self.backgroundView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.backgroundView.layer.shadowOpacity = 0.4
        self.backgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        self.backgroundView.layer.shadowRadius = 6.0
        self.backgroundView.layer.masksToBounds = false
        
        self.variant1Width.constant = 0.0
        self.variant2Width.constant = 0.0
        self.variant3Width.constant = 0.0
    }
    
    public func setVariants(withColors colors:[UIColor]) {
        
        let variantViews = [variant1, variant2, variant3]
        let variantViewWidths = [variant1Width, variant2Width, variant3Width]
        
        if colors.count > 1 {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
        
        for (index, color) in colors.enumerated() {
            if index > 2 {
                break
            }
            
            variantViews[index]?.backgroundColor = color            
            variantViewWidths[index]?.constant = 12.0
        }
        
        if colors.count > 1 {
            self.variantCount.text = "\(colors.count)"
        }
    }
}
