//
//  CommonTableViewController.swift
//  CommonUIKit
//
//  Created by Mayur Kothawade on 28/02/17.
//  Copyright © 2017 Coviam. All rights reserved.
//

@objc public enum ViewControllerLifeCycleEvents : Int {
    case didLoad = 0
    case willAppear
    case didAppear
    case willDisappear
    case didDisappear
    case willTransition
    case deInit
    case didLayoutSubviews
}

open class CommonTableViewController: UIViewController, CommonPresenterChangeSize,CustomBackButtonDelegate {
    
    //
    public var output : CommonDelegateAndDataSource? {
        didSet {
            self.dataSource = output
            self.delegate = output
        }
    }
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerSafeAreaView: UIView!
    @IBOutlet weak var footerSafeAreaHeight: NSLayoutConstraint!
    var tableView: UITableView {
        get {
            return containerView.subviews.first as! UITableView
        }
    }    
    public var dataSource : CommonTableViewDataSource?
    public var delegate : CommonTableViewDelegate?
    var tableViewBackgroundImageView : UIImageView?
    var tableStyle: UITableView.Style = .grouped
    
    public var tableview: UITableView {
        get {
            return self.tableView
        }
    }
    
    public var tableview_: UITableView? {
        get {
            return containerView?.subviews.first as? UITableView
        }
    }
    
    public var tableHeaderView: UIView? {
        get {
            return self.headerView
        }
    }
    
    public var tableFooterView: UIView? {
        get {
            return self.footerView
        }
    }
    
    public var tableHeaderHeightConstraint: NSLayoutConstraint? {
        get {
            return self.headerViewHeightConstraint
        }
    }
    
    public var tableFooterHeightConstraint: NSLayoutConstraint? {
        get {
            return self.footerViewHeightConstraint
        }
    }
    
    public var footerBackgroundColor: UIColor = .white {
        didSet {
            footerView.backgroundColor = footerBackgroundColor
            footerSafeAreaView.backgroundColor = footerBackgroundColor
        }
    }
    
    public var contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            self.tableView.contentInset = contentInset
        }
    }
    
    //
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public static func instantiate(dataSource : CommonTableViewDataSource?,delegate : CommonTableViewDelegate?, style: UITableView.Style = .plain) -> CommonTableViewController {
        let storyboard = UIStoryboard(name: "CommonTableViewController", bundle: Bundle(for: CommonTableViewController.self))
        var identifier = "CommonTableViewController"
        if style == .plain {
             identifier = "CommonPlainTableViewController"
        }
        let commonTableViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? CommonTableViewController
        commonTableViewController?.dataSource = dataSource
        commonTableViewController?.delegate = delegate
        commonTableViewController?.tableStyle = style
        
        return commonTableViewController!
    }
    
//    public convenience init(dataSource : CommonTableViewDataSource?,delegate : CommonTableViewDelegate?) {
//        let storyboard = UIStoryboard(name: "CommonTableViewController", bundle: Bundle(for: CommonTableViewController.self))
//        self = storyboard.instantiateViewController(withIdentifier: "CommonTableViewController")
//        self.dataSource = dataSource
//        self.delegate = delegate
//    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLayoutSubviews() {
        adjustTableViewContentInset()
        adjustTableViewBottomInset()
        handleEvent(event: .didLayoutSubviews)
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .allButUpsideDown
        }
        return .portrait
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        footerSafeAreaView.isHidden = true
        //
        if let customBackButton = self.dataSource?.customBackButton() {
            UtilityMethods.customBackButton(navigationController: navigationController, navigationItem: navigationItem, responder: self, image: customBackButton)
        } else {
            UtilityMethods.customBackButton(navigationController: navigationController, navigationItem: navigationItem, responder: self, image: nil)
        }
        
        //
        setTableViewDataSourceAndDelegate()
        
        //
        // By default, view 0 on height
        headerViewHeightConstraint.constant = 0.0
        
        if self.dataSource?.shouldEnableHorizontalSwipeGesture() ?? false {
            setUpSwipeGestureRecognizer(self)
        }
        
        // tableView's properties
        //tableView.estimatedRowHeight = 300
        tableView.estimatedSectionHeaderHeight = 55
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        // below iOS 11 shows 28 pixel space
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        setBackgroundColorForTableView()
        if let flag = self.delegate?.shouldShowSeparatorLine(),flag == false {
            self.tableView.separatorStyle = .none
        } else {
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        configureBackgroundImageView()
        handleEvent(event: .didLoad)
        reloadData(async:false)
    }
    
    var backgroundImageHeightConstraint : NSLayoutConstraint?
    
    func configureBackgroundImageView() {
        
        if self.delegate?.shouldShowBackgroundImage() == true {
            let backgroundImageView = UIImageView()
            backgroundImageView.contentMode = .scaleAspectFit
            let supportingView = UIView(frame: self.tableView.frame)
            supportingView.backgroundColor = UIColor.clear
            supportingView.addSubview(backgroundImageView)
            self.tableView.backgroundView = supportingView
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            let height = self.delegate?.heightForBackgroundImage() ?? 0.0
            supportingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":backgroundImageView]))
            let topConstraint = NSLayoutConstraint(item: backgroundImageView,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: supportingView,
                                                   attribute: .top,
                                                   multiplier: 1,
                                                   constant: 0.0)
            supportingView.addConstraint(topConstraint)
            let heightConstraint = NSLayoutConstraint(item: backgroundImageView,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: height)
            backgroundImageHeightConstraint = heightConstraint
            backgroundImageView.addConstraint(heightConstraint)
            tableViewBackgroundImageView = backgroundImageView
        }
    }
    
    public func reloadData(async:Bool = true){
        addHeaderView(async:async)
        addFooterView(async:async)
        addNavigationItemTitleView()
        DispatchQueue.main.async {
            if let rightBarButtonItems = self.dataSource?.rightBarButtonItems(for: self) {
                self.navigationItem.rightBarButtonItems = rightBarButtonItems
            } 
        }
        
        if let _ = delegate?.shouldReload(tableView: tableView) {
            tableView.reloadData()
        }
        if let imageView = self.tableViewBackgroundImageView {
            self.delegate?.setupBackgroundImageView(imageView: imageView, completionBlock: {
                self.backgroundImageHeightConstraint?.constant = self.delegate?.heightForBackgroundImage() ?? 0.0
            })
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
    
    public func addFooterView(async:Bool = true) {
        let addFooterBlock : ()->() = {
            for subview  in self.footerView.subviews {
                subview.removeFromSuperview()
            }
            if let height = self.dataSource?.heightForFooterView(for: self) {
                self.footerViewHeightConstraint.constant = height
                self.adjustTableViewBottomInset()
            }
            if let footer = self.dataSource?.getFooterView(for: self) {
                self.footerSafeAreaView.isHidden = false
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
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nvc = self.navigationController {
            let backgroundColor = dataSource?.navigationBarColor() ?? UIColor.white
            let titleColor = dataSource?.navigationTitleColor() ?? UIColor.black
            UtilityMethods.set(backgroundColor: backgroundColor, foregroundColor: titleColor, for: nvc.navigationBar)
            nvc.navigationBar.isTranslucent = false
        }
        if let title = dataSource?.navigationTitle() {
            self.navigationItem.title = title
        }
        self.setNavigationView()
        
        handleEvent(event: .willAppear)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    deinit {
        handleEvent(event: .deInit)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func handleEvent(event:ViewControllerLifeCycleEvents,otherInfo:[String:Any]?=nil) {
        self.delegate?.handleEvent(withControllerLifeCycle: event, viewController: self, otherInfo: otherInfo)
    }
    
    // CustomBackButtonDelegate
    
    internal func backToPreviousController() {
        dataSource?.willDismissController(viewController: self, completionHandler: {
            self.dataSource?.customBackButtonAction(for: self)
        })
    }
    
    fileprivate func setBackgroundColorForTableView() {
        if let color = self.dataSource?.backgroundColorForTableView() {
            self.tableView.backgroundColor = color
            self.view.backgroundColor = color
        }
    }
    
    fileprivate func setNavigationView() {
        if let navigationCustomView = self.dataSource?.getNavigationView(for: self) as? UIView {
            navigationCustomView.translatesAutoresizingMaskIntoConstraints = false
            navigationCustomView.tag = 9999
            self.navigationController?.view.addSubview(navigationCustomView)
            let views = ["navigationCustomView":navigationCustomView]
            let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[navigationCustomView]|", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: nil, views: views)
            self.navigationController?.view.addConstraints(widthConstraints)
            self.navigationController?.view.addConstraint(NSLayoutConstraint.init(item: navigationCustomView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.navigationController?.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 8.0))
            self.navigationController?.view.addConstraint(NSLayoutConstraint.init(item: navigationCustomView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant:60.0))
        }
    }
    
    fileprivate func addNavigationItemTitleView() {
        DispatchQueue.main.async {
            if let titleView = self.dataSource?.getNavigationTitleView(for: self) {
                self.navigationItem.titleView = titleView
            }
        }
    }
    
    override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let dict = ["newCollection":newCollection,"coordinator":coordinator] as [String : Any]
        self.handleEvent(event: .willTransition, otherInfo: dict)
        self.adjustTableViewContentInset()
        self.adjustTableViewBottomInset()
    }
    
    fileprivate func adjustTableViewContentInset() {
        if let _ = dataSource?.getNavigationView(for: self) as? UIView {
            if let height = self.navigationController?.navigationBar.frame.size.height{
                let diff = (80 - height - 20)
                self.tableView.contentInset = UIEdgeInsets(top: diff, left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    fileprivate func adjustTableViewBottomInset() {
        if let _ = dataSource?.getFooterView(for: self) {
            self.tableView.contentInset = UIEdgeInsets(top: self.contentInset.top, left: self.contentInset.left, bottom: self.footerViewHeightConstraint.constant, right: self.contentInset.right)
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func setTableViewDataSourceAndDelegate(){
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        //tableView.style = tableStyle
        
        if let ids = dataSource?.reusableIdentifiers() {
            for id in ids {
                self.tableView.register(BaseTableViewCell.self, forCellReuseIdentifier:id)
            }
        }
        if let ids = dataSource?.reusableNibsIdentifier() {
            for id in ids {
                if let _ = Bundle.main.path(forResource: id, ofType: "nib") {
                    tableView.register(UINib(nibName: id, bundle: Bundle.main), forCellReuseIdentifier: id)
                } else if let className = UtilityMethods.getClass(from: id) {
                    let bundle = Bundle(for: className.self)
                    guard let index = id.index(of: ".") else { return }
                    let subS = id.prefix(through: index)
                    tableView.register(UINib(nibName: id.replacingOccurrences(of: subS, with: ""), bundle: bundle), forCellReuseIdentifier: id)
                } else {
                    tableView.register(UINib(nibName: id, bundle: Bundle(for: CommonTableViewController.self)), forCellReuseIdentifier: id)
                }
            }
        }
        if let ids = dataSource?.reusableIdentifiersForSimpleTableViewCell() {
            for id in ids {
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: id)
            }
        }
        if let ids = dataSource?.reusableIdentifiersForHeaderFooterView() {
            for id in ids {
                tableView.register(BaseTableHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: id)
            }
        }
    }
    
    fileprivate func setUpSwipeGestureRecognizer(_ viewController: CommonTableViewController) {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        viewController.tableview_?.addGestureRecognizer(leftSwipe)
        viewController.tableview_?.addGestureRecognizer(rightSwipe)
    }

    @objc fileprivate func handleSwipeGestures(_ sender: UISwipeGestureRecognizer) {
        delegate?.handleSwipeGestures(direction: sender.direction)
    }
}

public protocol CommonTableViewDataSource: UITableViewDataSource {
    
    func reusableIdentifiers() -> [String]?
    func reusableNibsIdentifier() -> [String]?
    func reusableIdentifiersForSimpleTableViewCell() -> [String]?
    func reusableIdentifiersForHeaderFooterView() -> [String]?
    
    func navigationTitle() -> String
    func navigationTitleColor() -> UIColor?
    func navigationBarColor() -> UIColor?
    
    //
    func customBackButton() -> UIImage?
    func customBackButtonAction(for viewController: CommonTableViewController)
    func willDismissController(viewController: CommonTableViewController, completionHandler: @escaping () -> ())
    
    // These both are required to show the sticky header in the sidemenu
    func getHeaderView(for viewController: CommonTableViewController) -> UIView?
    func heightForHeaderView(for viewController: CommonTableViewController) -> CGFloat
    
    // These both are required to show the sticky footer
    func getFooterView(for viewController: CommonTableViewController) -> UIView?
    func heightForFooterView(for viewController: CommonTableViewController) -> CGFloat
    
    func safeAreaBackgroundColor() -> UIColor
    
    func getNavigationView(for viewController: CommonTableViewController) -> UIView?
    func backgroundColorForTableView() -> UIColor?
    
    //For Right menu items in Navigation bar
    func rightBarButtonItems(for viewController: CommonTableViewController) -> [UIBarButtonItem]?
    func getNavigationTitleView(for viewController: CommonTableViewController) -> UIView?
    func shouldEnableHorizontalSwipeGesture() -> Bool
}

public extension CommonTableViewDataSource {
    func navigationTitle() -> String { return "" }
    func navigationTitleColor() -> UIColor? { return nil }
    func navigationBarColor() -> UIColor? { return nil }
    
    func reusableIdentifiers() -> [String]? { return nil }
    func reusableNibsIdentifier() -> [String]? { return nil }
    func reusableIdentifiersForSimpleTableViewCell() -> [String]? { return nil }
    func reusableIdentifiersForHeaderFooterView() -> [String]? { return nil }
    
    func customBackButton() -> UIImage? { return nil }
    
    func customBackButtonAction(for viewController: CommonTableViewController) {
        if viewController.navigationController?.popViewController(animated: true) == nil {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    func willDismissController(viewController: CommonTableViewController, completionHandler: @escaping () -> ()) {completionHandler()}
    
    func getHeaderView(for viewController: CommonTableViewController) -> UIView? { return nil }
    func heightForHeaderView(for viewController: CommonTableViewController) -> CGFloat { return 0 }
    
    func getFooterView(for viewController: CommonTableViewController) -> UIView? { return nil }
    func heightForFooterView(for viewController: CommonTableViewController) -> CGFloat { return 0 }
    func getNavigationView(for viewController: CommonTableViewController) -> UIView? { return nil }
    func backgroundColorForTableView() -> UIColor? { return UIColor.groupTableViewBackground }
    
    func rightBarButtonItems(for viewController: CommonTableViewController) -> [UIBarButtonItem]?{ return nil}
    func getNavigationTitleView(for viewController: CommonTableViewController) -> UIView? {return nil}
    func shouldEnableHorizontalSwipeGesture() -> Bool { return false }
    
    func safeAreaBackgroundColor() -> UIColor { return .white }
}

public protocol CommonTableViewDelegate: UITableViewDelegate {
    func shouldShowSeparatorLine() -> Bool
    func shouldReload(tableView: UITableView) -> Bool
    func handleEvent(withControllerLifeCycle event:ViewControllerLifeCycleEvents,viewController:CommonTableViewController,otherInfo:[String:Any]?)
    func shouldShowBackgroundImage() -> Bool
    func heightForBackgroundImage() -> CGFloat
    // please do call completionBlock in implementation once you are done with imageView setup
    func setupBackgroundImageView(imageView: UIImageView, completionBlock: @escaping () -> ())
    /// Return the datasource's shouldEnableHorizontalSwipeGesture method as true and implement the below method
    func handleSwipeGestures(direction: UISwipeGestureRecognizer.Direction)
}

public protocol CommonDelegateAndDataSource : CommonTableViewDataSource, CommonTableViewDelegate {
    
}

public extension CommonTableViewDelegate {
    func handleEvent(withControllerLifeCycle event:ViewControllerLifeCycleEvents,viewController:CommonTableViewController,otherInfo:[String:Any]?) {}
    func shouldReload(tableView: UITableView) -> Bool { return true }
    
    func shouldShowBackgroundImage() -> Bool { return false }
    func heightForBackgroundImage() -> CGFloat { return 0.0 }
    func setupBackgroundImageView(imageView: UIImageView, completionBlock: @escaping () -> ()) {completionBlock()}
    func handleSwipeGestures(direction: UISwipeGestureRecognizer.Direction) {}
}
