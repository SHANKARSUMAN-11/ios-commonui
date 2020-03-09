//
//  ViewController.swift
//  PlaceholderAnimation
//
//  Created by Yudiz on 30/05/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import UIKit

var associateObjectValue: Int = 0

class ShimmerShadowView: UIView {
    
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
        layer.cornerRadius = 6.0
        self.shimmerAnimation = true
        self.backgroundColor = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
        containerView.layer.cornerRadius = 6.0
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

class ShimmerBackgroundView: UIView {
    
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
        layer.cornerRadius = 10.0
        containerView.layer.cornerRadius = 6.0
        containerView.layer.masksToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4.0
        
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

// MARK: - UIView Extension
extension UIView {
    
    fileprivate var isAnimate: Bool {
        get {
            return objc_getAssociatedObject(self, &associateObjectValue) as? Bool ?? false
        }
        set {
            return objc_setAssociatedObject(self, &associateObjectValue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var shimmerAnimation: Bool {
        get {
            return isAnimate
        }
        set {
            self.isAnimate = newValue
        }
    }
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
}

/// ViewController
class ShimmerViewController: UIViewController {

    /// IBOutlet(s)
    @IBOutlet weak var tableView: UITableView!
    
    typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void
    
    /// Variable Declaration(s)
    var isAnimateStart: Bool = false

    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //startAnimation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = ShimmerViewController.makeSlideIn(duration: 0.5, delayFactor: 0.25)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: -tableView.bounds.width, y: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    final class Animator {
        private var hasAnimatedAllCells = false
        private let animation: Animation
        
        init(animation: @escaping Animation) {
            self.animation = animation
        }
        
        func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
            guard !hasAnimatedAllCells else {
                return
            }
            
            animation(cell, indexPath, tableView)
            
            hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
        }
    }
}

extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        
        return lastIndexPath == indexPath
    }
}

// MARK: - UI Related
extension ShimmerViewController {
    
    func prepareUI() {
        
    }
}

// MARK: - Animation Related
extension ShimmerViewController {
    
    func startAnimation() {
        for animateView in getSubViewsForAnimate() {
            animateView.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.gray.withAlphaComponent(0.6).cgColor, UIColor.gray.withAlphaComponent(0.83).cgColor, UIColor.gray.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.frame = animateView.bounds
            animateView.layer.mask = gradientLayer
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 1.0
            animation.fromValue = -animateView.frame.size.width
            animation.toValue = animateView.frame.size.width
            animation.repeatCount = .infinity
            
            gradientLayer.add(animation, forKey: "")
        }
    }
    
    func stopAnimation() {
        for animateView in getSubViewsForAnimate() {
            animateView.layer.removeAllAnimations()
            animateView.layer.mask = nil
        }
    }
}

// MARK: - Other Method(s)
extension ShimmerViewController {

    func getSubViewsForAnimate() -> [UIView] {
        var obj: [UIView] = []
        for objView in view.subviewsRecursive() {
            obj.append(objView)
        }
        return obj.filter({ (obj) -> Bool in
            obj.shimmerAnimation
        })
    }
}

// MARK: - UIButton Action(s)
extension ShimmerViewController {
    
    @IBAction func tapBtnRefresh(_ sender: UIBarButtonItem) {
        if isAnimateStart {
            startAnimation()
            sender.title = "Stop"
        } else {
            stopAnimation()
            sender.title = "Start"
        }
        isAnimateStart = !isAnimateStart
    }
}

// MARK: - UITableView Delegate and DataSource
extension ShimmerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return 4
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        case 2:
            if UI_USER_INTERFACE_IDIOM() == .pad {
                cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath)
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
    }
}
