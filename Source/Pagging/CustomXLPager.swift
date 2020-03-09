//
//  PaggingViewController.swift
//  Demo
//
//  Created by Rahul Pengoria on 29/07/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit

public protocol CustomXLPagerViewDataSource {
    
    /**
     Configure controllers for each tab and there should not be same refrence of controller in array
     */
    func controllers(for: CustomXLPager) -> [UIViewController]
    
    /**
     Set Tab title with this method for segment style textOnly,imageOnTop, imageOnLeft but no need to add this method if using custom view
     */
    func title(for: ScrollableSegmentedControl?, in: CustomXLPager) -> [String]?
    
    /**
     Set Tab images with this method for segment style imageOnly,imageOnTop, imageOnLeft but no need to add this method if using custom view
     */
    func images(for: ScrollableSegmentedControl?, in: CustomXLPager) -> [UIImage]?
    
    /**
     Configure attributes for default segment control but no need to add this method if using custom view
     */
    func attributes(for: ScrollableSegmentedControl?) -> SegementedControlAttributes
    
    /**
     Configure attributes for CustomXLPager
     */
    func configure(for: CustomXLPager?) -> CustomXLPagerConfig
    
    /**
     Configure custom view instead of default segment control
     */
    func customView(for: ScrollableSegmentedControl?, in: CustomXLPager) -> ScrollableSegmentedControl?
}

public extension CustomXLPagerViewDataSource {
    func title(for: ScrollableSegmentedControl?, in: CustomXLPager) -> [String]? {return nil}
    func images(for: ScrollableSegmentedControl?, in: CustomXLPager) -> [UIImage]? {return nil}
    func attributes(for: ScrollableSegmentedControl?) -> SegementedControlAttributes {return SegementedControlAttributes()}
    func customView(for: ScrollableSegmentedControl?, in: CustomXLPager) -> ScrollableSegmentedControl? {return nil}
}

public protocol CustomXLPagerViewDelegate {
    func handleEvent(withControllerLifeCycle event: ViewControllerLifeCycleEvents, viewController: CustomXLPager, otherInfo:[String:Any]?)
    func didFinishTransition(for: CustomXLPager, selectedController: UIViewController?, pageIndex: Int)
    
}

public extension CustomXLPagerViewDelegate {
    func handleEvent(withControllerLifeCycle event: ViewControllerLifeCycleEvents, viewController: CustomXLPager, otherInfo:[String:Any]?) {}
    func didFinishTransition(for: CustomXLPager, selectedController: UIViewController?, pageIndex: Int) {}
}


/**
 A CustomXLPagerSegementedControl is view pager controller for showing tabs and related controllers.
 */
public class SegementedControlAttributes: NSObject {
    
    /// segementedControl Content Color
    public var segmentContentColor: UIColor = .black
    
    /// Segemented Control tint color
    public var segementedControlTintColor: UIColor = .groupTableViewBackground
    
    /// Selected Segemented Control content color
    public var selectedSegmentContentColor: UIColor = .red
    
    /// Segemented Control backgroundColor
    public var backgroundColor: UIColor = .white
    
    public var titleAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Effra-Regular", size: 16.0) as Any]
}

public class CustomXLPagerConfig: NSObject {
    
    /**
     Configure height for segment control
     */
    public var heightForSegmentedControl: CGFloat = 50
    
    /**
     Configure segment control EdgeInsets
     */
    public var segmentControlEdgeInsets: UIEdgeInsets?
    
    /**
     Configure container EdgeInsets
     */
    public var containerViewEdgeInsets: UIEdgeInsets?
    
    /**
     Configure pageView EdgeInsets and always set top inset if you want to Configure padding betwen segment control and pageview
     */
    public var pageViewEdgeInsets: UIEdgeInsets?
    
    /**
     Configure segement style : textOnly, imageOnly, imageOnTop, imageOnLeft
     */
    public var segmentControlStyle: ScrollableSegmentedControlSegmentStyle = .textOnly
    
    /**
     The index number identifying the first selected Tab
     */
    public var selectedIndex: Int = 0
    /**
     A Boolean value that determines if the width of all segments is going to be fixed or not.
     
     When this value is set to true all segments have the same width which equivalent of the width required to display the text that requires the longest width to be drawn.
     The default value is true.
     */
    public var fixedSegmentWidth: Bool = false
    
    /**
     Configure background color of CustomXLPager
     */
    public var backgroungColorForCustomXLPager: UIColor = .white
    
    public var cornerRadius: CGFloat = 0.0
    public var shadowRadius: CGFloat = 0.0
    public var shadowColor: CGColor = UIColor.black.cgColor
    public var shadowOpacity: Float = 0.12
    public var shadowOffset = CGSize(width: 1.0, height: 1.0)
    
    /**
     Configure the underline view for the selected tab
     */
    public var underlineConfig: UnderlineConfig = UnderlineConfig()

}


public struct UnderlineConfig {
    /**
     Set this to false to hide the underline
     */
    public var showUnderLine: Bool = true
    
    /**
     Set this for increase or decrease of underline height and also set the height of segmented control accordingly
     */
    public var heightOfSelectedTabUnderline: CGFloat = 4
    
    /**
     Set this to increase/decrease the translation duration when a tab is tapped
     */
    public var translationDuration: Double = 0.3
    
    /**
     Set this to change the color of underline, default value is the color of selected Segment
     */
    public var backgroundColor: UIColor?
}

private class UnderlineContainer: UIScrollView {
    var underlineView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    func commoninit() {
        self.isUserInteractionEnabled = false
        underlineView = UIView()
        addSubview(underlineView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/**
 CustomXLPagerView is a Container View Controller that allows us to switch easily among a collection of view controllers, It shows a interactive indicator of the current, previous, next child view controllers.
 */
public class CustomXLPager: UIViewController {
    
    public var segmentedControl: ScrollableSegmentedControl?
    private var currentIndex = 0
    private var pageController = CommonWalkthroughController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var controller = [UIViewController]()
    public var dataSource: CustomXLPagerViewDataSource?
    public var delegate: CustomXLPagerViewDelegate?
    private var containerView: UIView?
    private var underlineContainer: UnderlineContainer?
    private var underlineView: UIView?
    private var currentTabItem: UICollectionViewCell?
    private var tapHelperBool: Bool = false
    
    
    public var selectedSegmentIndex: Int = -1 {
        didSet{
            if let segmentedControl = self.segmentedControl {
                segmentedControl.selectedSegmentIndex = selectedSegmentIndex
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        setupContainerView()
        setUpPageController()
        handleEvent(event: .didLoad)
    }
    
    private func setupControllers() {
        if let viewControllers = dataSource?.controllers(for: self) {
            self.controller = viewControllers
        }
        if let config = dataSource?.configure(for: self)  {
            self.view.backgroundColor = config.backgroungColorForCustomXLPager
        }
    }
    
    public func reloadXLPager() {
        self.pageController.removeFromParent()
        self.pageController.willMove(toParent: nil)
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        setupControllers()
        self.pageController = CommonWalkthroughController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
        setupContainerView()
        setUpPageController()
        
        /*
          Underline view needs segment cells to for frame calculation so wait for sometime for cells loading
        */

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.setupUnderlineView()
            self.setUpScrollViewDelegate()
        }
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard dataSource?.configure(for: self).underlineConfig.showUnderLine ?? true else { return }
        let duration = (self.dataSource?.configure(for: self).underlineConfig.translationDuration ?? 0.3)/3
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
            self.currentTabItem = self.segmentedControl?.collectionView?.cellForItem(at: IndexPath(item: self.currentIndex, section: 0))
            self.scrollToItemAnimation(duration)
        }
    }
    
    override open func viewDidLayoutSubviews() {
        handleEvent(event: .didLayoutSubviews)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleEvent(event: .willAppear)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if dataSource?.configure(for: self).underlineConfig.showUnderLine ?? true, underlineView == nil {
            setupUnderlineView()
            //for coordinating the underline with swiping between pages
            setUpScrollViewDelegate()
        }
        handleEvent(event: .didAppear)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleEvent(event: .willDisappear)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        handleEvent(event: .didDisappear)
    }
    
    fileprivate func handleEvent(event:ViewControllerLifeCycleEvents,otherInfo:[String:Any]?=nil) {
        self.delegate?.handleEvent(withControllerLifeCycle: event, viewController: self, otherInfo: otherInfo)
    }
    
    public func resetSegmentedController() {
        self.segmentedControl?.removeFromSuperview()
        self.setupSegmentedView()
    }
    
    func setUpScrollViewDelegate() {
        for toBeScrollView in self.pageController.view.subviews {
            if let scrollView = toBeScrollView as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }
    
    private func setUpPageController() {
        pageController.walkthroughDelegate = self
        pageController.walkthroughDataSource = self
        
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
        self.pageController.view.anchor(top: self.containerView?.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: dataSource?.configure(for: self).pageViewEdgeInsets?.top ?? 0.0, paddingLeft: dataSource?.configure(for: self).pageViewEdgeInsets?.left ?? 0.0, paddingBottom: dataSource?.configure(for: self).pageViewEdgeInsets?.bottom ?? 0.0, paddingRight: dataSource?.configure(for: self).pageViewEdgeInsets?.right ?? 0.0, width: 0, height: 0)
        
        if let container = self.containerView {
            self.view.bringSubviewToFront(container)
        }
    }
    
    private func setupContainerView() {
        let segmentHeight = segmentedHeight()
        self.containerView = UIView()
        self.containerView?.backgroundColor = dataSource?.attributes(for: self.segmentedControl).backgroundColor
        if let shadowRadius = dataSource?.configure(for: self).shadowRadius, shadowRadius > 0.0 {
            containerView?.layer.shadowRadius = shadowRadius
            containerView?.layer.shadowOpacity = dataSource?.configure(for: self).shadowOpacity ?? 0.12
            containerView?.layer.shadowColor = dataSource?.configure(for: self).shadowColor ?? UIColor.black.cgColor
            containerView?.layer.shadowOffset = dataSource?.configure(for: self).shadowOffset ?? CGSize(width: 1.0, height: 1.0)
        }
        
        if let container = self.containerView {
            self.view.addSubview(container)
            container.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: dataSource?.configure(for: self).containerViewEdgeInsets?.top ?? 0, paddingLeft: dataSource?.configure(for: self).containerViewEdgeInsets?.left ?? 0, paddingBottom: 0, paddingRight: dataSource?.configure(for: self).containerViewEdgeInsets?.right ?? 0, width: 0, height: segmentHeight)
            setupSegmentedView()
        }
        
    }
    
    
    private func updateUnderlineView(_ underlineView: UIView, _ segmentedControl: ScrollableSegmentedControl) {
        if currentTabItem == nil {
            currentTabItem = segmentedControl.collectionView?.cellForItem(at: IndexPath(item: currentIndex, section: 0))
        }
        
        let originX = (self.currentTabItem?.frame.origin.x ?? underlineView.frame.origin.x)
        let width = self.currentTabItem?.frame.width ?? underlineView.frame.size.width
        
        underlineView.frame.origin.x = originX
        underlineView.frame.size.width = width
    }
    
    private func segmentedHeight() -> CGFloat {
        let type: ScrollableSegmentedControlSegmentStyle = dataSource?.configure(for: self).segmentControlStyle ?? .textOnly
        return dataSource?.configure(for: self).heightForSegmentedControl ?? (type == .imageOnTop ? 75 : 50)
    }
    
    private func setupSegmentedView() {
        if let customView = dataSource?.customView(for: self.segmentedControl, in: self) {
            self.segmentedControl = customView
        } else {
            self.segmentedControl = ScrollableSegmentedControl()
            let type = dataSource?.configure(for: self).segmentControlStyle ?? .textOnly
            segmentedControl?.segmentStyle = type
            insertSegment(style: type)
            setSegmentControlAttributes()
        }
        
        if let segmentedView = self.segmentedControl {
            var segmentedControlBottomConstraint: NSLayoutYAxisAnchor? = containerView?.bottomAnchor
            containerView?.addSubview(segmentedView)
            
            if dataSource?.configure(for: self).underlineConfig.showUnderLine ?? true {
                if self.underlineContainer == nil {
                    self.underlineContainer = UnderlineContainer(frame: .zero)
                }
                guard let underlineContainerView = self.underlineContainer else { return }
                
                containerView?.addSubview(underlineContainerView)
                segmentedControlBottomConstraint = nil
                underlineContainerView.anchor(top: segmentedControl?.bottomAnchor, left: containerView?.leftAnchor, bottom: containerView?.bottomAnchor, right: containerView?.rightAnchor, paddingTop: dataSource?.configure(for: self).segmentControlEdgeInsets?.top ?? 0.0, paddingLeft: dataSource?.configure(for: self).segmentControlEdgeInsets?.left ?? 0.0, paddingBottom: dataSource?.configure(for: self).segmentControlEdgeInsets?.bottom ?? 0.0, paddingRight: dataSource?.configure(for: self).segmentControlEdgeInsets?.right ?? 0.0, width: 0, height: self.dataSource?.configure(for: self).underlineConfig.heightOfSelectedTabUnderline ?? 4)
            }
            
            segmentedView.anchor(top: containerView?.topAnchor, left: containerView?.leftAnchor, bottom: segmentedControlBottomConstraint, right: containerView?.rightAnchor, paddingTop: dataSource?.configure(for: self).segmentControlEdgeInsets?.top ?? 0.0, paddingLeft: dataSource?.configure(for: self).segmentControlEdgeInsets?.left ?? 0.0, paddingBottom: dataSource?.configure(for: self).segmentControlEdgeInsets?.bottom ?? 0.0, paddingRight: dataSource?.configure(for: self).segmentControlEdgeInsets?.right ?? 0.0, width: 0, height: 0)
            
            if let cornerRadius = dataSource?.configure(for: self).cornerRadius, cornerRadius > 0.0 {
                containerView?.layer.cornerRadius = cornerRadius
                if dataSource?.configure(for: self).segmentControlEdgeInsets == nil {
                    segmentedView.layer.cornerRadius = cornerRadius
                }
            }
            segmentedControl?.underlineHeight = 0
            segmentedControl?.tabDelegate = self
        }

        segmentedControl?.addTarget(self, action: #selector(changeTab), for: .valueChanged)
        
    }
    
    private func setupUnderlineView() {
        underlineView = underlineContainer?.underlineView
        
        let backgroundColor = dataSource?.configure(for: self).underlineConfig.backgroundColor ?? segmentedControl?.selectedSegmentContentColor
        underlineView?.backgroundColor = backgroundColor
        guard let segmentedControlCollectionView = segmentedControl?.collectionView else { return }
        
        currentTabItem = segmentedControlCollectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0))
        underlineContainer?.contentSize = segmentedControlCollectionView.contentSize
        
        guard let currentTabItem = currentTabItem else { return }
        underlineView?.frame = CGRect(x: currentTabItem.frame.minX, y: 0, width: currentTabItem.frame.width, height: self.dataSource?.configure(for: self).underlineConfig.heightOfSelectedTabUnderline ?? 4)
    }
    
    private func setSegmentControlAttributes() {
        if let specification = dataSource?.attributes(for: self.segmentedControl) {
            segmentedControl?.tintColor = specification.segementedControlTintColor
            segmentedControl?.segmentContentColor = specification.segmentContentColor
            segmentedControl?.selectedSegmentContentColor = specification.selectedSegmentContentColor
            segmentedControl?.backgroundColor = specification.backgroundColor
            segmentedControl?.setTitleTextAttributes(specification.titleAttributes, for: .normal)
            segmentedControl?.fixedSegmentWidth = dataSource?.configure(for: self).fixedSegmentWidth ?? true
            segmentedControl?.selectedSegmentIndex = dataSource?.configure(for: self).selectedIndex ?? 0
            self.currentIndex = dataSource?.configure(for: self).selectedIndex ?? 0
            segmentedControl?.underlineSelected = true
        }
    }
    
    private func insertSegment(style: ScrollableSegmentedControlSegmentStyle) {
        
        switch style {
        case .textOnly:
            if let titles = dataSource?.title(for: self.segmentedControl, in: self) {
                for (index, title) in titles.enumerated() {
                    segmentedControl?.insertSegment(withTitle: title, at: index)
                }
            }
        case .imageOnly:
            if let images = dataSource?.images(for: self.segmentedControl, in: self) {
                for (index, image) in images.enumerated() {
                    segmentedControl?.insertSegment(with: image, at: index)
                }
            }
        case .imageOnTop, .imageOnLeft:
            if let titles = dataSource?.title(for: self.segmentedControl, in: self), let images = dataSource?.images(for: self.segmentedControl, in: self), titles.count == images.count {
                for (index, title) in titles.enumerated() {
                    segmentedControl?.insertSegment(withTitle: title, image: images[index], at: index)
                }
            }
        }
    }
    
    @objc func changeTab() {
        if let count = segmentedControl?.numberOfSegments,
            let index = segmentedControl?.selectedSegmentIndex,
            count > index,
            index != currentIndex,
            let controller = viewController(at: index){
            // This bool helps to track if pages are changed by tapping the tabs or swiping the pager view
            tapHelperBool = true
            if index > currentIndex {
                DispatchQueue.main.async {
                  self.pageController.setViewControllers([controller], direction: .forward, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.pageController.setViewControllers([controller], direction: .reverse, animated: true, completion: nil)
                }
            }

            if dataSource?.configure(for: self).underlineConfig.showUnderLine ?? true {
                // Jump to the tab
                if index + 1 != currentIndex, index - 1 != currentIndex {
                    currentIndex = index
                    currentTabItem = segmentedControl?.collectionView?.cellForItem(at: IndexPath(row: currentIndex, section: 0))

                    scrollToItemAnimation(self.dataSource?.configure(for: self).underlineConfig.translationDuration ?? 0.3)
                }
                
            }
            currentIndex = index
            currentTabItem = segmentedControl?.collectionView?.cellForItem(at: IndexPath(row: currentIndex, section: 0))

            delegate?.didFinishTransition(for: self, selectedController: activeController(), pageIndex: currentIndex)

        }
    }
    
    private func scrollToItemAnimation(_ animationDuration: Double) {
        UIView.animate(withDuration: animationDuration, animations: {
            if let underline = self.underlineView, let segmentedControl = self.segmentedControl {
                self.updateUnderlineView(underline, segmentedControl)
            }
        })
    }
    
    public func activeController() -> UIViewController? {
        if controller.count > currentIndex {
            return controller[currentIndex]
        }
        return nil
    }
    
    private func viewController(at index: Int) -> UIViewController? {
        if let count = segmentedControl?.numberOfSegments, count == controller.count, count > index {
            return controller[index]
        }
        return nil
    }
    
}

extension CustomXLPager: CommonWalkthroughControllerDataSource, CommonWalkthroughControllerDelegate {
    
    public func didFinishTransition(for: CommonWalkthroughController, with: UIViewController, prevButton: UIButton, nextButton: UIButton, pageIndex: Int) {
        segmentedControl?.selectedSegmentIndex = pageIndex
    }
    
    public func controllers(for: CommonWalkthroughController) -> [UIViewController] {
        return controller
    }
    
    public func shouldShowPageControl(for: CommonWalkthroughController) -> Bool {
        return false
    }
    
    public func shouldCreateTransitionButtons() -> Bool {
        return false
    }
    
    public func firstController(for: CommonWalkthroughController) -> Int {
        return self.dataSource?.configure(for: self).selectedIndex ?? 0
    }
    
}

extension CustomXLPager: TabDelegateCustomXLPager {
    
    public func didFinishScrollingAnimationSegmentedControl(_ scrollView: UIScrollView) {
        let duration = (self.dataSource?.configure(for: self).underlineConfig.translationDuration ?? 0.3)/3
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            self.scrollToItemAnimation(duration)
        }
    }
    
    public func didEndScrollingSegmentedControl(_ scrollView: UIScrollView) {
        underlineContainer?.contentOffset.x = scrollView.contentOffset.x
    }
}


extension CustomXLPager: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let segmentedControl = segmentedControl else { return }
        guard let visibleIndexPaths = segmentedControl.collectionView?.indexPathsForVisibleItems else { return }
        guard scrollView.contentOffset.x == scrollView.frame.width || visibleIndexPaths.contains(IndexPath(item: currentIndex, section: 0)) else { return }
        guard let underline = underlineView else { return }
        
        var ratio: CGFloat = 0
        if scrollView.contentOffset.x == 2 * scrollView.frame.width {
            ratio = 1
        } else {
            ratio = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.width) / scrollView.frame.width
        }
        
        var originX = (self.currentTabItem?.frame.origin.x ?? underline.frame.minX)
        
        if scrollView.contentOffset.x == scrollView.frame.width {
            
            //  Moving the position of underline View after scrolling
            tapHelperBool = false
            scrollToItemAnimation(self.dataSource?.configure(for: self).underlineConfig.translationDuration ?? 0.3)
            
        } else if scrollView.contentOffset.x > scrollView.frame.width, !tapHelperBool {
            
            // Consider moving forward
            if currentIndex < segmentedControl.numberOfSegments - 1 {
                originX += ratio * (underline.frame.width)
                UIView.animate(withDuration: 0.01, animations: {
                    underline.frame.origin.x = originX
                })
            }
            
        } else if !tapHelperBool {
            // Consider moving reverse
            if currentIndex > 0 {
                originX -= (1 - ratio) * (underline.frame.width)
                UIView.animate(withDuration: 0.01, animations: {
                    underline.frame.origin.x = originX
                })
            }
        }
        
    }
}

