//
//  CommonCollectionViewController.swift
//  BlibliMobile-iOS
//
//  Created by Sagar Daundkar on 23/03/2017.
//  Copyright © 2017 Coviam, PT. All rights reserved.
//

import UIKit

open class CommonCollectionViewController: UIViewController, CustomBackButtonDelegate, CommonPresenterChangeSize {

    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var footerView: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    public var collectionview: UICollectionView {
        get {
            return self.collectionView
        }
    }
    
    public var delegate : CommonCollectionViewDelegate?
    public var dataSource : CommonCollectionViewDataSource?
    
    public convenience init(dataSource : CommonCollectionViewDataSource?,delegate : CommonCollectionViewDelegate?) {
        self.init(nibName: "CommonCollectionViewController", bundle: Bundle(for: CommonCollectionViewController.self))
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addFooterView()
        addHeaderView()
        handleEvent(event: .didLoad)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nvc = self.navigationController {
            let backgroundColor = dataSource?.navigationBarColor() ?? UIColor.white
            let titleColor = dataSource?.navigationTitleColor() ?? UIColor.black
            UtilityMethods.set(backgroundColor: backgroundColor, foregroundColor: titleColor, for: nvc.navigationBar)
            nvc.navigationBar.isTranslucent = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationItem.leftBarButtonItems = nil
        if self.dataSource?.shouldDisplayBackButton() == true {
            if let customBackButton = self.dataSource?.customBackButton() {
                UtilityMethods.customBackButton(navigationController: navigationController, navigationItem: navigationItem, responder: self, image: customBackButton)
            } else {
                UtilityMethods.customBackButton(navigationController: navigationController, navigationItem: navigationItem, responder: self, image: nil)
            }
        }
        if let rightBarButtonItems = self.dataSource?.rightBarButtonItems(for: self) {
            self.navigationItem.rightBarButtonItems = rightBarButtonItems
        }
        handleEvent(event: .willAppear)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleEvent(event: .didAppear)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        handleEvent(event: .willDisappear)
        super.viewWillDisappear(animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        handleEvent(event: .didDisappear)
        super.viewDidDisappear(animated)
    }
    
    deinit {
        handleEvent(event: .deInit)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard delegate?.shrinkOnKeyboardAppeared() == true,
            let info = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = info.cgRectValue.size.height
        bottomConstraint.constant = keyboardHeight
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
    func setupView() {
        if self.delegate?.shouldLoad(collectionView: collectionView, for: self) == true {
            self.collectionView.dataSource = self.dataSource
            self.collectionView.delegate = self.delegate
        }
        
        self.registerNibs()
        if let title = self.dataSource?.navigationTitle() {
            self.navigationItem.title = title
        }
        setupCollectionView()
    }
    
    func setupCollectionView() {
        if let color = dataSource?.collectionViewBackgroundColor() {
            collectionView.backgroundColor = color
            self.view.backgroundColor = color
        }
    }
    
    func registerNibs() {
        
        dataSource?.reusableIdentifiers()?.forEach {
            collectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: $0)
        }
        dataSource?.reusableNibsIdentifier()?.forEach {
            collectionView.register(UINib(nibName: $0, bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: $0)
        }
        dataSource?.reusableHeaderNibsIdentifier()?.forEach {
            collectionView.register(UINib(nibName: $0, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: $0)
        }
        dataSource?.blankHeaderIdentifier()?.forEach {
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: $0)
        }
        dataSource?.reusableFooterNibsIdentifier()?.forEach {
            collectionView.register(UINib(nibName: $0, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: $0)
        }
        dataSource?.reusableHeaderIdentifier()?.forEach {
            collectionView.register(BaseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: $0)
        }
        dataSource?.reusableFooterIdentifier()?.forEach {
            collectionView.register(BaseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: $0)
        }
    }
    
    //MARK: - CustomBackButtonDelegate
    
    internal func backToPreviousController() {
        dataSource?.customBackAction {
            if self.navigationController?.popViewController(animated: true) == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .allButUpsideDown
        }
        return .portrait
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if self.delegate?.shouldLoad(collectionView: collectionView, for: self) == true {
            coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.layoutIfNeeded()
            }, completion: { (UIViewControllerTransitionCoordinatorContext) in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.layoutIfNeeded()
            })
        }
    }
    
    public func addFooterView(async:Bool = true) {
        let addFooterBlock : ()->() = {
            for subview  in self.footerView.subviews {
                subview.removeFromSuperview()
            }
            if let height = self.dataSource?.heightForFooterView(for: self) {
                self.footerViewHeightConstraint.constant = height
            }
            if let footer = self.dataSource?.getFooterView(for: self) {
                self.footerView.addSubview(footer)
                footer.translatesAutoresizingMaskIntoConstraints = false
                self.footerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":footer]))
                self.footerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":footer]))
            }
        }
        if async == true {
            DispatchQueue.main.async {
                addFooterBlock()
            }
        }
        else {
            addFooterBlock()
        }
    }

    public func addHeaderView(async:Bool = true) {
        let addHeaderBlock : ()->() = {
            for subview  in self.headerView.subviews {
                subview.removeFromSuperview()
            }
            if let height = self.dataSource?.heightForHeaderView(for: self) {
                self.headerViewHeightConstraint.constant = height
            }
            if let header = self.dataSource?.getHeaderView(for: self) {
                self.headerView.addSubview(header)
                header.translatesAutoresizingMaskIntoConstraints = false
                self.headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":header]))
                self.headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":header]))
            }
        }
        if async == true {
            DispatchQueue.main.async {
                addHeaderBlock()
            }
        }
        else {
            addHeaderBlock()
        }
    }
    
    func handleEvent(event:ViewControllerLifeCycleEvents,otherInfo:[String:Any]?=nil) {
        self.delegate?.handleEvent(withControllerLifeCycle: event, viewController: self, otherInfo: otherInfo)
    }
    
}

public protocol CommonCollectionViewDataSource: UICollectionViewDataSource {

    func reusableIdentifiers() -> [String]?
    func reusableNibsIdentifier() -> [String]?
    func reusableHeaderIdentifier() -> [String]?
    func reusableFooterIdentifier() -> [String]?
    func reusableHeaderNibsIdentifier() -> [String]?
    func reusableFooterNibsIdentifier() -> [String]?
    func blankHeaderIdentifier() -> [String]?
    func navigationTitle() -> String?
    func navigationTitleColor() -> UIColor?
    func navigationBarColor() -> UIColor?
    func collectionViewBackgroundColor() -> UIColor
    func getFooterView(for viewController: CommonCollectionViewController) -> UIView?
    func heightForFooterView(for viewController: CommonCollectionViewController) -> CGFloat
    func getHeaderView(for viewController: CommonCollectionViewController) -> UIView?
    func heightForHeaderView(for viewController: CommonCollectionViewController) -> CGFloat
    func rightBarButtonItems(for viewController: CommonCollectionViewController) -> [UIBarButtonItem]?
    func customBackButton() -> UIImage?
    func customBackAction(completionHandler: @escaping () -> ())
    func shouldDisplayBackButton() -> Bool
    
}

public protocol CommonCollectionViewDelegate: UICollectionViewDelegate {
    func shouldLoad(collectionView:UICollectionView,for: CommonCollectionViewController) -> Bool
    func handleEvent(withControllerLifeCycle event:ViewControllerLifeCycleEvents,viewController:CommonCollectionViewController,otherInfo:[String:Any]?)
    func shrinkOnKeyboardAppeared() -> Bool
}

public extension CommonCollectionViewDataSource {
    func collectionViewBackgroundColor() -> UIColor {
        return .white
    }
    func navigationTitle() -> String? { return nil }
    func navigationTitleColor() -> UIColor? { return nil}
    func navigationBarColor() -> UIColor? { return nil}
    func reusableNibsIdentifier() -> [String]? { return nil }
    func reusableIdentifiers() -> [String]? { return nil }
    func reusableHeaderNibsIdentifier() -> [String]?  { return nil }
    func blankHeaderIdentifier() -> [String]?  { return nil }
    func reusableFooterNibsIdentifier() -> [String]? { return nil }
    func reusableHeaderIdentifier() -> [String]? { return nil }
    func reusableFooterIdentifier() -> [String]? { return nil }
    func getFooterView(for viewController: CommonCollectionViewController) -> UIView? {return nil}
    func heightForFooterView(for viewController: CommonCollectionViewController) -> CGFloat { return 0 }
    func getHeaderView(for viewController: CommonCollectionViewController) -> UIView? { return nil }
    func heightForHeaderView(for viewController: CommonCollectionViewController) -> CGFloat { return 0 }
    func rightBarButtonItems(for viewController: CommonCollectionViewController) -> [UIBarButtonItem]?{ return nil}
    func customBackButton() -> UIImage? { return nil }
    func customBackAction(completionHandler: @escaping () -> ()) { completionHandler() }
    func shouldDisplayBackButton() -> Bool { return true }
}

public extension CommonCollectionViewDelegate {
    func handleEvent(withControllerLifeCycle event:ViewControllerLifeCycleEvents,viewController:CommonCollectionViewController,otherInfo:[String:Any]?) {}
    func shouldLoad(collectionView:UICollectionView,for: CommonCollectionViewController) -> Bool { return true }
    func shrinkOnKeyboardAppeared() -> Bool { return false }
}
