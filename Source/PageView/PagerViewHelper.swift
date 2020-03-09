//
//  PagerViewHelper.swift
//  CommonPagerView
//
//  Created by RONAK GARG on 27/05/19.
//  Copyright © 2019 Ronak garg. All rights reserved.
//
import UIKit

public protocol PagerViewConfigurationProtocol {
    func getPageControlConfig() -> PageControlConfig
    func getPagerViewConfig() -> PagerViewConfig
}
public protocol PagerViewHelperDelegate {
    func didTapPageName()
}
extension PagerViewHelperDelegate {
    func didTapPageName() {}
}
public class PagerViewHelper: NSObject, CommonCollectionViewDataSource, CommonCollectionViewDelegate {
    
    fileprivate var pageControl: PageControl?
    public var vc: CommonCollectionViewController?
    public var isPagingEnabled = true
    fileprivate var customBubble: CustomBubble?
    internal weak var collectionViewLayout: PagerViewLayout?
    internal var dataHandler : ((UICollectionView, IndexPath, UIView, Any?)-> Void)?
    internal var reusableIdentifier : String = String()
    internal var data: [Any]?
    internal var delegateHandler: ((UICollectionView, IndexPath, Any?)-> Void)?
    internal var timer: Timer?
    internal var numberOfSections = 0
    fileprivate var possibleTargetingIndexPath: IndexPath?
    fileprivate var pagerViewConfigDelegate: PagerViewConfigurationProtocol
    public var delegate: PagerViewHelperDelegate?
    public var shouldShowPageName: Bool = true
    fileprivate var labelData: [String] = []
    @objc public fileprivate(set) dynamic var currentIndex: Int = 0
    public var pageNameFont: UIFont?
    public var pagerViewConfig = PagerViewConfig()
    public init(withPagerConfigDelegate delegate: PagerViewConfigurationProtocol) {
        self.pagerViewConfigDelegate = delegate
    }
    
    /// The percentage of x position at which the origin of the content view is offset from the origin of the pagerView view.
    @objc
    fileprivate var scrollOffset: CGFloat {
        if let controller = vc, let layout = self.collectionViewLayout {
            let contentOffset = max(controller.collectionview.contentOffset.x, controller.collectionview.contentOffset.y)
            let scrollOffset = Double(contentOffset/layout.itemSpacing)
            return fmod(CGFloat(scrollOffset), CGFloat(self.data?.count ?? 0))
        }
        return 0
    }
    
    /// Requests that PagerView use the default value for a given distance.
    static let automaticDistance: UInt = 0

    /// Scrolls the pager view contents until the specified item is visible.
    ///
    /// - Parameters:
    ///   - index: The index of the item to scroll into view.
    ///   - animated: Specify true to animate the scrolling behavior or false to adjust the pager view’s visible content immediately.
    fileprivate func scrollToItem(at index: Int, animated: Bool) {
        guard isPagingEnabled else {
            return
        }
        guard index < (self.data?.count ?? 0) else {
            fatalError("index \(index) is out of range [0...\((self.data?.count ?? 0)-1)]")
        }
        let indexPath = { () -> IndexPath in
            if let indexPath = self.possibleTargetingIndexPath, indexPath.item == index {
                defer {
                    self.possibleTargetingIndexPath = nil
                }
                return indexPath
            }
            return self.numberOfSections > 1 ? self.nearbyIndexPath(for: index) : IndexPath(item: index, section: 0)
        }()
        if let contentOffset = self.collectionViewLayout?.contentOffset(for: indexPath) {
            self.vc?.collectionview.setContentOffset(contentOffset, animated: animated)
        }
    }
    
    public func setData(data: [Any], labelData: [String] = []) {
        self.data = data
        self.labelData = labelData
        self.pageControl?.numberOfPages = data.count
    }
    
    public func setHandler(reusableIdentifier: String, dataHandler: @escaping (UICollectionView, IndexPath, UIView, Any?)-> Void, delegateHandler: @escaping (UICollectionView, IndexPath, Any?)-> Void) {
        self.reusableIdentifier = reusableIdentifier
        self.dataHandler = dataHandler
        self.delegateHandler = delegateHandler
    }
    
    public func reloadData(with data:[Any], labelData: [String] = []) {
        self.setData(data: data, labelData:labelData)
        DispatchQueue.main.async {
            self.collectionViewLayout?.forceInvalidate()
            self.vc?.collectionview.reloadData()
        }
    }
    
    // MARK: - Private functions
    fileprivate func startTimer() {
        guard self.timer == nil else {
            return
        }
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.pagerViewConfig.automaticSlidingInterval), target: self, selector: #selector(self.flipNext(sender:)), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    
    fileprivate func cancelTimer() {
        guard self.timer != nil else {
            return
        }
        self.timer!.invalidate()
        self.timer = nil
    }
    
    @objc
    fileprivate func flipNext(sender: Timer?) {
        guard let _ = self.vc?.collectionview.superview, let _ = self.vc?.collectionview.window, let count = self.data?.count, count > 0, let layout = self.collectionViewLayout else {
            return
        }
        let contentOffset: CGPoint = {
            let indexPath = self.centermostIndexPath
            let section = self.numberOfSections > 1 ? (indexPath.section+(indexPath.item+1)/(self.data?.count ?? 0)) : 0
            let item = (indexPath.item+1) % (self.data?.count ?? 0)
            return layout.contentOffset(for: IndexPath(item: item, section: section))
        }()
        self.vc?.collectionview.setContentOffset(contentOffset, animated: true)
    }
    
    fileprivate func nearbyIndexPath(for index: Int) -> IndexPath {
        // Is there a better algorithm?
        let currentIndex = self.currentIndex
        let currentSection = self.centermostIndexPath.section
        if abs(currentIndex-index) <= (self.data?.count ?? 0)/2 {
            return IndexPath(item: index, section: currentSection)
        } else if (index-currentIndex >= 0) {
            return IndexPath(item: index, section: currentSection-1)
        } else {
            return IndexPath(item: index, section: currentSection+1)
        }
    }
    
    fileprivate var centermostIndexPath: IndexPath {
        guard (data?.count ?? 0) > 0, vc?.collectionview.contentSize != .zero else {
            return IndexPath(item: 0, section: 0)
        }
        if let controller = vc, let layout = collectionViewLayout {
            let sortedIndexPaths = controller.collectionview.indexPathsForVisibleItems.sorted { (l, r) -> Bool in
                let leftFrame = layout.frame(for: l)
                let rightFrame = layout.frame(for: r)
                var leftCenter: CGFloat,rightCenter: CGFloat,ruler: CGFloat
                switch pagerViewConfig.scrollDirection {
                case .horizontal:
                    leftCenter = leftFrame.midX
                    rightCenter = rightFrame.midX
                    ruler = controller.collectionview.bounds.midX
                case .vertical:
                    leftCenter = leftFrame.midY
                    rightCenter = rightFrame.midY
                    ruler = controller.collectionview.bounds.midY
                }
                return abs(ruler-leftCenter) < abs(ruler-rightCenter)
            }
            let indexPath = sortedIndexPaths.first
            if let indexPath = indexPath {
                return indexPath
            }
        }
        return IndexPath(item: 0, section: 0)
    }
    
    fileprivate func setupCollectionView() {
        pagerViewConfig = pagerViewConfigDelegate.getPagerViewConfig()
        if !isPagingEnabled {
            if let layout = vc?.collectionview.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = pagerViewConfig.scrollDirection
                vc?.collectionview.collectionViewLayout = layout
            }
           vc?.collectionview.decelerationRate = UIScrollView.DecelerationRate.normal
        } else {
            let collectionViewLayout = PagerViewLayout()
            collectionViewLayout.helper = self
            self.collectionViewLayout = collectionViewLayout
            vc?.collectionview.decelerationRate = UIScrollView.DecelerationRate.fast
            vc?.collectionview.collectionViewLayout = collectionViewLayout
            if pagerViewConfig.automaticSlidingInterval > 0 {
                self.cancelTimer()
                self.startTimer()
            }
        }
        vc?.collectionview.showsVerticalScrollIndicator = false
        vc?.collectionview.showsHorizontalScrollIndicator = false
        if #available(iOS 10.0, *),
            let collectionView = vc?.collectionview,
            collectionView.responds(to: #selector(setter: collectionView.isPrefetchingEnabled)) {
            collectionView.isPrefetchingEnabled = false
        }
        if #available(iOS 11.0, *),
            let collectionView = vc?.collectionview,
            collectionView.responds(to: #selector(setter: collectionView.contentInsetAdjustmentBehavior)) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        vc?.collectionview.reloadData()
    }
    
    fileprivate func setupPageControl() {
        let pageControl = PageControl()
        pageControl.numberOfPages = self.data?.count ?? 0
        let config = pagerViewConfigDelegate.getPageControlConfig()
        pageControl.itemSpacing = config.itemSpacing
        pageControl.interitemSpacing = config.interitemSpacing
        pageControl.contentInsets = config.contentInsets
        pageControl.hidesForSinglePage = config.hidesForSinglePage
        pageControl.contentHorizontalAlignment = config.contentHorizontalAlignment
        pageControl.setFillColor(config.fillColorForSelected, for: .selected)
        pageControl.setFillColor(config.fillColorForNormal, for: .normal)
        pageControl.setupPageControlStyle(style: config.style, for: .selected)
        self.pageControl = pageControl
        vc?.view.addSubview(pageControl)
        self.setupPageControlConstraints(for: config.contentHorizontalAlignment, and: pageControl)
        vc?.view.bringSubviewToFront(pageControl)
        pageControl.isHidden = !config.shouldShowPageControl
    }
    
    fileprivate func setupPageControlConstraints(for contentHorizontalAlignment: UIControl.ContentHorizontalAlignment, and pageControl: UIView) {
        switch contentHorizontalAlignment {
        case .left:
            pageControl.anchor(top: nil, left: vc?.view.leftAnchor, bottom: vc?.view.bottomAnchor, right: self.customBubble?.leftAnchor, paddingTop: 0, paddingLeft: 8+pagerViewConfig.interitemSpacing+pagerViewConfig.horizontalInset, paddingBottom: pagerViewConfig.verticalInset, paddingRight: 8, width: 0, height: 0)
            if let anchor = self.customBubble?.centerYAnchor {
                pageControl.centerYAnchor.constraint(equalTo: anchor, constant: 0).isActive = true
            }
        case .right:
            pageControl.anchor(top: nil, left: self.customBubble?.rightAnchor, bottom: vc?.view.bottomAnchor, right: vc?.view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: pagerViewConfig.verticalInset, paddingRight: 8+pagerViewConfig.interitemSpacing+pagerViewConfig.horizontalInset, width: 0, height: 0)
            if let anchor = self.customBubble?.centerYAnchor {
                pageControl.centerYAnchor.constraint(equalTo: anchor, constant: 0).isActive = true
            }
        case .center:
            pageControl.anchor(top: nil, left: nil, bottom: vc?.view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: pagerViewConfig.verticalInset, paddingRight: 0, width: 0, height: 0)
            if let anchor = self.vc?.view?.centerXAnchor {
                pageControl.centerXAnchor.constraint(equalTo: anchor, constant: 0).isActive = true
            }
        default:
            break
        }
    }
    
    fileprivate func setupPageName() {
        if self.labelData.isEmpty {
            return
        }
        
        let view = CustomBubble()
        view.setBackgroundColor(color: UIColor.black.withAlphaComponent(0.64))
        view.setBorderColor(color: .clear)
        view.clipsToBounds = true
        customBubble = view
        customBubble?.leftSeparator.isHidden = false
        customBubble?.mainButtonAction = {(sender) in
            self.delegate?.didTapPageName()
        }
        setupBubbleText(with: self.labelData, for: self.currentIndex)
        vc?.view.addSubview(view)
        self.setupLabelConstraints(for: pagerViewConfigDelegate.getPageControlConfig().contentHorizontalAlignment, for: view)
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.size.height/2
        }
        vc?.view.bringSubviewToFront(view)
        view.isHidden = !shouldShowPageName
    }
    
    fileprivate func setupBubbleText(with string: [String], for currentPage: Int) {
        customBubble?.leftButtonTitle = "\(currentPage+1)/\(self.data?.count ?? 0)"
        customBubble?.setMainButtonTitle("\(string[currentPage])", titleColor: .white)
        customBubble?.setFont(withFont: pageNameFont)
    }
    fileprivate func setupLabelConstraints(for contentHorizontalAlignment: UIControl.ContentHorizontalAlignment?, for view: UIView) {
        guard let alignment = contentHorizontalAlignment else {
            return
        }
        switch alignment {
        case .left:
            view.anchor(top: nil, left: nil, bottom: vc?.view.bottomAnchor, right: vc?.view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight:8+pagerViewConfig.interitemSpacing+pagerViewConfig.horizontalInset, width: 0, height: 0)
        case .right:
            view.anchor(top: nil, left: vc?.view.leftAnchor, bottom: vc?.view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8+pagerViewConfig.interitemSpacing+pagerViewConfig.horizontalInset, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        default:
            break
        }
    }
    //MARK:- CommonCollectionViewDataSource
    public func reusableIdentifiers() -> [String]? {
        return [reusableIdentifier]
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let baseCell = BaseCollectionViewCell.dequeueReusableCell(for: collectionView, with: reusableIdentifier, indexPath: indexPath)
        guard let cell = baseCell as? BaseCollectionViewCell,
            let customView = cell.customView  else {
                return UICollectionViewCell()
        }
        dataHandler?(collectionView,indexPath,customView, data?[indexPath.row])
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard (data?.count ?? 0) > 0 else {
            return 0
        }
        numberOfSections = pagerViewConfig.isInfiniteScrolling && ((data?.count ?? 0) > 1 || !pagerViewConfig.removesInfiniteLoopForSingleItem) ? Int(Int16.max)/(data?.count ?? 0) : 1
        return numberOfSections
    }
    //MARK:- CommonCollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToItem(at: indexPath.row, animated: true)
        possibleTargetingIndexPath = indexPath
        defer {
            possibleTargetingIndexPath = nil
        }
        delegateHandler?(collectionView, indexPath, data?[indexPath.row])
    }
    
    public func handleEvent(withControllerLifeCycle event: ViewControllerLifeCycleEvents, viewController: CommonCollectionViewController, otherInfo: [String : Any]?) {
        if event == .didLoad {
            setupCollectionView()
            setupPageName()
            setupPageControl()
        }
    }
    
    public  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard isPagingEnabled else {
            return
        }
        if let layout = collectionViewLayout {
            let contentOffset = pagerViewConfig.scrollDirection == .horizontal ? targetContentOffset.pointee.x : targetContentOffset.pointee.y
            let targetItem = lround(Double(contentOffset/layout.itemSpacing))
            pageControl?.currentPage = targetItem % (data?.count ?? 0)
            setupBubbleText(with: self.labelData, for: targetItem % (data?.count ?? 0))
            if pagerViewConfig.automaticSlidingInterval > 0 {
                startTimer()
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isPagingEnabled else {
            return
        }
        if let count = self.data?.count, count > 0 {
            // In case someone is using KVO
            let currentIndex = lround(Double(self.scrollOffset)) % count
            if (currentIndex != self.currentIndex) {
                self.currentIndex = currentIndex
            }
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard isPagingEnabled else {
            return
        }
        pageControl?.currentPage = self.currentIndex
        setupBubbleText(with: self.labelData, for: self.currentIndex)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard isPagingEnabled else {
            return
        }
        if pagerViewConfig.automaticSlidingInterval > 0 {
            cancelTimer()
        }
    }
}
extension PagerViewHelper: UICollectionViewDelegateFlowLayout {
   public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return pagerViewConfig.itemSize
    }
    
   public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return pagerViewConfig.interitemSpacing
    }
    
   public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: pagerViewConfig.verticalInset, left: pagerViewConfig.horizontalInset, bottom: pagerViewConfig.verticalInset, right: pagerViewConfig.horizontalInset)
    }
}
