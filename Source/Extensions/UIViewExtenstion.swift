//
//  UIViewExtenstion.swift
//  CommonUIKit
//
//  Created by Mayur Kothawade on 27/03/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

// MARK: - Lock View
extension UIView {
    
    public func roundedCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    public func isLocked() -> Bool {
        if let _ = viewWithTag(10) {
            return true
        }
        return false
    }
    
    public func lock() {
        self.lock(nil)
    }
    
    public func lock(_ navigationItem: UINavigationItem?) {
        self.lock(navigationItem, activityIndicator: true)
    }
    
    public func lock(_ navigationItem: UINavigationItem?, activityIndicator: Bool) {
        self.lock(navigationItem, activityIndicator: activityIndicator, tapRecognizer: nil)
    }
    
    public func lock(_ navigationItem: UINavigationItem?, activityIndicator: Bool, tapRecognizer: UITapGestureRecognizer?) {
        self.lock(navigationItem, activityIndicator: activityIndicator, tapRecognizer: tapRecognizer, alpha: 0.75)
    }
    
    public func lock(_ navigationItem: UINavigationItem?, activityIndicator: Bool, tapRecognizer: UITapGestureRecognizer?, alpha: CGFloat) {
        DispatchQueue.main.async {
            if let _ = self.viewWithTag(10) {
                //View is already locked
            } else {
                UIApplication.shared.beginIgnoringInteractionEvents()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                let lockView = UIView(frame: CGRect(x: self.bounds.minX,
                                                    y: self.bounds.minY,
                                                    width: UIScreen.main.bounds.width,
                                                    height: UIScreen.main.bounds.height))
                lockView.backgroundColor = UIColor(white: 0.0, alpha: alpha)
                lockView.tag = 10
                lockView.alpha = 0.0
                
                if tapRecognizer != nil {
                    lockView.addGestureRecognizer(tapRecognizer!)
                }
                
                if activityIndicator == true {
                    let activity = UIActivityIndicatorView(style: .white)
                    activity.hidesWhenStopped = true
                    activity.center = lockView.center
                    activity.translatesAutoresizingMaskIntoConstraints = false
                    
                    lockView.addSubview(activity)
                    activity.startAnimating()
                    
                    var constraints: [NSLayoutConstraint] = []
                    constraints.append(NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: lockView, attribute: .centerX, multiplier: 1, constant: 0))
                    constraints.append(NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: lockView, attribute: .centerY, multiplier: 1, constant: 0))
                    NSLayoutConstraint.activate(constraints)
                }
                self.addSubview(lockView)
                
                UIView.animate(withDuration: 0.2, animations: {
                    lockView.alpha = 1.0
                })
            }
        }
        
    }
    
    public func unlock() {
        self.unlock(nil)
    }
    
    public func unlock(_ navigationItem: UINavigationItem?) {
        DispatchQueue.main.async {
            if let lockView = self.viewWithTag(10) {
                UIApplication.shared.endIgnoringInteractionEvents()
                UIView.animate(withDuration: 0.2, animations: {
                    lockView.alpha = 0.0
                }, completion: { finished in
                    lockView.removeFromSuperview()
                })
            }
        }
    }
    
    public func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
        
    @objc public func anchor(top : NSLayoutYAxisAnchor?, left : NSLayoutXAxisAnchor?, bottom : NSLayoutYAxisAnchor?,right : NSLayoutXAxisAnchor?,paddingTop : CGFloat,paddingLeft : CGFloat,paddingBottom : CGFloat, paddingRight : CGFloat,width : CGFloat,height : CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if(width != 0){
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if(height != 0){
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }

    public func setGradient(with colors: [UIColor]?, from: CGPoint, to: CGPoint) {
        
        if let gradientLayer = self.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        
        if let colors = colors {
            
            if colors.count == 1 {
                self.backgroundColor = colors.first
            } else {
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.startPoint = from
                gradientLayer.endPoint = to
                
                let bounds = self.bounds
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: self.frame.height)
                
                gradientLayer.colors = colors.map{ $0.cgColor }
                
                self.layer.insertSublayer(gradientLayer, at: 0)
            }
        }
    }
    
    public func addShadowView(radius: CGFloat, shadowOffset: CGSize = CGSize.zero, shadowColor: UIColor = .lightGray, shadowOpacity: Float = 1.3) {
        //Remove previous shadow views
        superview?.viewWithTag(119900)?.removeFromSuperview()
        
        //Create new shadow view with frame
        let shadowView = UIView(frame: frame)
        shadowView.tag = 119900
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOffset = shadowOffset
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.shadowRadius = radius
        shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        
        superview?.insertSubview(shadowView, belowSubview: self)
    }
    
    public func addShadow(radius: CGFloat, shadowOffset: CGSize = .zero, shadowColor: UIColor = .lightGray, shadowOpacity: Float = 0.2) {
        //        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = radius
        layer.shadowOffset = shadowOffset
    }
    
    @discardableResult public func showEmptyState(withTitle title: NSAttributedString?, description: NSAttributedString?, image: UIImage?, buttonTitle: NSAttributedString?, completion:@escaping (EmptyStateBackgroundView) -> ()) -> EmptyStateBackgroundView? {
        
        let emptyView: EmptyStateBackgroundView? = {
            let ev = EmptyStateBackgroundView()
            ev.buttonTitle = buttonTitle
            ev.title = title
            ev.message = description
            ev.image = image
            addSubview(ev)
            ev.translatesAutoresizingMaskIntoConstraints =  false
            ev.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            ev.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            ev.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            ev.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            ev.isHidden = false
            
            ev.didTapEmptyStateButton = completion
            return ev
        }()
        
        emptyView?.isHidden = false
        return emptyView
    }
}
