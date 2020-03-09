//
//  CommonWalkthroughtViewController.swift
//  CommonWalkthrough
//
//  Created by Rahul Pengoria on 07/03/19.
//  Copyright © 2019 com.walkthrough.pengoria. All rights reserved.
//

import UIKit


/// Postion of buttons and page control
///
/// - bottom: bottom of screen
/// - middle: center of screen
/// - top: top of screen
public enum WalkthroughPosition {
    case bottom
    case middle
    case top
}

public class CommonWalkthroughController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var controllers = [UIViewController]()
    public var walkthroughDataSource: CommonWalkthroughControllerDataSource?
    private var pageControl : UIPageControl = UIPageControl()
    private var backButton = UIButton()
    private var nextButton = UIButton()
    private var currentIndex = 0
    private var pendingIndex = 0
    public var walkthroughDelegate: CommonWalkthroughControllerDelegate?
    private var transitionInProgress = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let controllers = walkthroughDataSource?.controllers(for: self) {
            self.controllers = controllers
            self.currentIndex = walkthroughDataSource?.firstController(for: self) ?? 0
            if controllers.count > 0, controllers.count > self.currentIndex {
                self.setViewControllers([controllers[self.currentIndex]], direction: .forward, animated: true, completion: nil )
            }
            handlePageControl()
            handleButtons()
        }
    }
    
    public override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleButtons() {
        if let showButton = walkthroughDataSource?.shouldCreateTransitionButtons(), let _ = walkthroughDelegate?.didCreateTransitionButtons(previousButton: self.backButton, nextButton: self.nextButton), showButton {
            self.view.addSubview(backButton)
            self.view.addSubview(nextButton)
            self.backButton.translatesAutoresizingMaskIntoConstraints = false
            self.nextButton.translatesAutoresizingMaskIntoConstraints = false
            if let postion = walkthroughDataSource?.position(for: (self.backButton,self.backButton)) {
                self.transitionButtonPosition(button: self.backButton, postion: postion.0, yOffSet: postion.1)
                self.transitionButtonPosition(button: self.nextButton, postion: postion.0, yOffSet: postion.1)
            }
            self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
            self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
            self.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
            self.backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
            self.backButton.isHidden = (self.currentIndex == 0)
        }
    }
    
    @objc func nextButtonTapped(_ sender: Any) {
        if !transitionInProgress, self.currentIndex + 1 < controllers.count {
            self.currentIndex += 1
            setViewController(direction: .forward)
        }
    }
    
    private func setViewController(direction: NavigationDirection) {
        transitionInProgress = true
        DispatchQueue.main.async {
            self.setViewControllers([self.controllers[self.currentIndex]], direction: direction, animated: true) { (success) in
                if success {
                    self.didFinishTransition()
                    self.transitionInProgress = false
                }
            }
        }
    }
    
    @objc func backButtonTapped(_ sender: Any) {
        if !transitionInProgress, self.currentIndex - 1 >= 0 {
            self.currentIndex -= 1
            setViewController(direction: .reverse)
        }
    }
    
    private func handlePageControl() {
        if let shouldShow = walkthroughDataSource?.shouldShowPageControl(for: self), shouldShow {
            self.view.addSubview(self.pageControl)
            self.pageControl.translatesAutoresizingMaskIntoConstraints = false
            self.pageControl.numberOfPages = controllers.count
            self.pageControl.currentPage = 0
            
            if let pageControl = walkthroughDataSource?.pageControl(for: self) {
                self.pageControl.pageIndicatorTintColor = pageControl.pageIndicatorTintColor
                self.pageControl.currentPageIndicatorTintColor = pageControl.currentPageIndicatorTintColor
                self.pageControl.transform = pageControl.transform
                pageControlPosition(position: pageControl.position, yOffset: pageControl.yOffset)
            }
        }
    }
    
    private func pageControlPosition(position: WalkthroughPosition, yOffset: CGFloat) {
        
        switch position {
        case .top:
            self.pageControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topPadding() + yOffset).isActive = true
            self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        case .bottom:
            self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(bottomPadding() + yOffset)).isActive = true
            self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            
        case .middle:
            self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            self.pageControl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0 + yOffset).isActive = true
        }
    }
    
    private func transitionButtonPosition(button: UIButton, postion: WalkthroughPosition, yOffSet: CGFloat) {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        switch postion {
        case .top:
            button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topPadding() + yOffSet).isActive = true
        case .bottom:
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(bottomPadding() + yOffSet)).isActive = true
        case .middle:
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0 + yOffSet).isActive = true
        }
    }
    
    func topPadding() -> CGFloat {
        let window = UIApplication.shared.keyWindow
        var topPadding : CGFloat = 8.0
        if #available(iOS 11.0, *) {
            topPadding = window?.safeAreaInsets.top ?? 8.0
        }
        return topPadding
    }
    
    func bottomPadding() -> CGFloat {
        let window = UIApplication.shared.keyWindow
        var bottomPadding : CGFloat = 8.0
        if #available(iOS 11.0, *) {
            bottomPadding = window?.safeAreaInsets.bottom ?? 8.0
        }
        return bottomPadding
    }
    
    private func didFinishTransition() {
        self.backButton.isHidden = (self.currentIndex == 0)
        self.nextButton.isHidden = false
        self.pageControl.currentPage = self.currentIndex
        self.walkthroughDelegate?.didFinishTransition(for: self, with: controllers[self.currentIndex], prevButton: self.backButton, nextButton: self.nextButton, pageIndex: self.currentIndex)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController), index != 0{
            return controllers[index - 1]
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController), index + 1 <  controllers.count {
            return controllers[index + 1]
        }
        return nil
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let index = controllers.firstIndex(of: pendingViewControllers[0]) {
            self.pendingIndex = index
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.currentIndex = self.pendingIndex
            self.didFinishTransition()
        } else {
            self.pendingIndex = self.currentIndex
        }
    }

}

public protocol CommonWalkthroughControllerDataSource {
    
    
    /// Add UIViewController to Walkthrough
    ///
    /// - Parameter for: refrence of CommonWalkthroughController
    /// - Returns: return array of UIViewControllers
    func controllers(for: CommonWalkthroughController) -> [UIViewController]
    
    
    /// Page Control creation of page control
    ///
    /// - Parameter for: reference of CommonWalkthroughController
    /// - Returns: Return true if Page Control need to be created else false
    func shouldShowPageControl(for: CommonWalkthroughController) -> Bool
    
    
    /// Customize page control (position, offset etc..)
    /// Change Page Control functionality only if shouldShowPageControl(for: CommonWalkthroughController) return true
    ///
    /// - Parameter for: CommonWalkthroughController
    /// - Returns: Returns CommonWalkthroughPageControl
    func pageControl(for: CommonWalkthroughController) -> CommonWalkthroughPageControl
    
    /// Controls creating Tranisition Buttons (back and next buttons)
    ///
    /// - Returns: Return true if transition buttons need to be created else false
    func shouldCreateTransitionButtons() -> Bool
    /// Set postion for Transition Buttons(back and next buttons)
    /// only if shouldCreateTransitionButtons() return true
    /// - Parameter transitionButtons: (prev buttons, next buttons))
    /// - Returns: (Postion of buttons and yOffSet from certain position)
    func position(for transitionButtons: (UIButton, UIButton)) -> (WalkthroughPosition, CGFloat)
    
    func firstController(for: CommonWalkthroughController) -> Int
    
}

public extension CommonWalkthroughControllerDataSource {
    func shouldShowPageControl(for: CommonWalkthroughController) -> Bool { return true }
    func pageControl(for: CommonWalkthroughController) -> CommonWalkthroughPageControl { return CommonWalkthroughPageControl() }
    func position(for transitionButtons: (UIButton, UIButton)) -> (WalkthroughPosition, CGFloat) {return (.bottom, 0.0)}
    func shouldCreateTransitionButtons() -> Bool {return true}
    func firstController(for: CommonWalkthroughController) -> Int {return 0}
}

public protocol CommonWalkthroughControllerDelegate {
    
    /// Called every when transition from one controller to another
    ///
    /// - Parameters:
    ///   - for: refrence of CommonWalkthroughController
    ///   - with: current conntroller
    ///   - prevButton: refrence of prev button
    ///   - nextButton: refrence of next button
    ///   - pageIndex: index of current page
    func didFinishTransition(for : CommonWalkthroughController, with: UIViewController, prevButton:UIButton, nextButton:UIButton, pageIndex: Int)
    
    /// Customize Transition buttons
    ///
    /// - Parameters:
    ///   - previousButton: refrence of prev button
    ///   - nextButton: refrence of next button
    func didCreateTransitionButtons(previousButton: UIButton, nextButton: UIButton)
}

public extension CommonWalkthroughControllerDelegate {
    func didCreateTransitionButtons(previousButton: UIButton, nextButton: UIButton) {}
}




