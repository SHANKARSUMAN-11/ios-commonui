//
//  CustomTabbar.swift
//  sample
//
//  Created by Ashok Kumar on 19/05/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit

protocol CustomTabbarDelegate: class {
    func didTapBag(_ sender: UIButton, parent: Any)
}

@IBDesignable
class CustomTabbar: UITabBar {
    
    private var cartButtonWidth: CGFloat = 52.0
    private var view_: CustomView!
    private var shapeLayer: CALayer?
    public var cartButton = UIButton()
    
    public weak var delegate_: CustomTabbarDelegate?
    
    func addShapeLayer() {
        
        view_ = CustomView()
        view_.frame = self.bounds
        view_.addShape()
        view_.translatesAutoresizingMaskIntoConstraints = false
        view_.layer.masksToBounds = false
        view_.backgroundColor = UIColor.clear
        self.addSubview(view_)
        self.sendSubviewToBack(view_)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let translatedPoint = cartButton.convert(point, from: self)
        
        if (cartButton.bounds.contains(translatedPoint)) {
            //didTapBag(cartButton)
            //return cartButton.hitTest(translatedPoint, with: event)
        }
        return super.hitTest(point, with: event)
    }
    
    func addActionButton(withImage image: UIImage?) {
        self.cartButton.center = CGPoint(x: self.center.x, y: 0)
        
        var buttonRect = self.cartButton.frame
        buttonRect.origin.y = self.frame.maxY
        buttonRect.size.width = self.cartButtonWidth
        buttonRect.size.height = self.cartButtonWidth
        self.cartButton.frame = buttonRect
        cartButton.layer.shadowRadius = 6.0
        cartButton.layer.shadowColor = UIColor.gray.cgColor
        cartButton.layer.shadowOpacity = 0.3
        cartButton.layer.cornerRadius = cartButtonWidth/2
        cartButton.backgroundColor = UIColor(red: 243/255.0, green: 112/255.0, blue: 33/255.0, alpha: 1.0)
        cartButton.setImage(image, for: .normal)
        
        cartButton.addTarget(self, action: #selector(didTapBag(_:)), for: .touchUpInside)
        self.addSubview(cartButton)
        self.bringSubviewToFront(cartButton)
        
        /*
        UIView.animate(withDuration: 0.5) {
            buttonRect.origin.y = -20.0
            self.cartButton.frame = buttonRect
        }
        */
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.5, options: .curveEaseIn, animations: {
            buttonRect.origin.y = -20.0
            self.cartButton.frame = buttonRect
        }) { (_) in
            
        }
    }
    
    @objc func didTapBag(_ sender: UIButton) {
        delegate_?.didTapBag(sender, parent: self)
    }
    
    override func draw(_ rect: CGRect) {
        self.addShapeLayer()
        self.addActionButton(withImage: UIImage(named: "bag"))
    }
}

class CustomView: UIView {
    
    private var shapeLayer: CALayer?
    
    func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowRadius = 6.0
        shapeLayer.shadowColor = UIColor.lightGray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        
        let height: CGFloat = 40.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth + 38 - height * 2.5), y: 0)) // the beginning of the trough
        
        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth - 38 + height * 2.5), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRadius: CGFloat = 35
        return abs(self.center.x - point.x) > buttonRadius || abs(point.y) > buttonRadius
    }
    
    func createPathCircle() -> CGPath {
        
        let radius: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
