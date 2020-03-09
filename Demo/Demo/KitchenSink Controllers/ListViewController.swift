//
//  ListViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 14/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

enum ListItems: String, CaseIterable {
    //case Table = "Table View"
    case ProductCell = "Product Cell"
    case CustomCard = "Custom Card"
    case Button = "Button & Alert"
    case TextField = "Text Field"
    case TextView = "Text View"
    case Bubble = "Bubble"
    case Ticker = "Ticker"
    case DropDown = "Drop Down"
    case MultiSelect = "Multi Select"
    case CustomList = "List"
    case Toast = "Toast"
    case Tab = "Tab"
    case EmptyState = "Empty State"
    case pagerView = "Pager View"
    case customXlPagerView = "Custom XlPager View"
    case commonWalkThrough = "Common WalkThrough"
    case CustomLabelImageViewController = "CustomLabelButton"
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FloatingPanelControllerDelegate, FloatingPanelLayout {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Design System"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        self.showSheet()
        return
        
        if let topController = UIApplication.topMost {
//            let presenter = ForceUpdate()
            let presenter = UIViewController()
            presenter.view.backgroundColor = .gray
            presenter.modalPresentationStyle = .overFullScreen
            topController.present(presenter, animated: false, completion: {
                self.showSheet()
//                presenter.show()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Effra-Regular", size: 16.0)
        cell.textLabel?.text = ListItems.allCases[indexPath.row].rawValue
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ListItems.allCases[indexPath.row] {
        case .customXlPagerView:
            let helper = CustomXLPagerHelper()
            let controller = CustomXLPager()
            controller.dataSource = helper
            controller.delegate = helper
            self.navigationController?.pushViewController(controller, animated: true)
            
        case .commonWalkThrough:
            let helper = CommonWalkThroughHelper()
            let controller = CommonWalkthroughController()
            controller.walkthroughDataSource = helper
            controller.walkthroughDelegate = helper
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            performSegue(withIdentifier: ListItems.allCases[indexPath.row].rawValue, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    var mainPanelObserves: [NSKeyValueObservation] = []
    var mainPanelVC: FloatingPanelController?
    var presenter = UIViewController()
    
    func showSheet() {
        
        if let topController = UIApplication.topMost {
            
            if let mainPanelVC = self.mainPanelVC {
                mainPanelVC.removePanelFromParent(animated: true) {
                    self.showForceUpdatePopup(on: topController)
                }
            } else {
                self.showForceUpdatePopup(on: topController)
            }
            
        }
    }
    
    func showForceUpdatePopup(on: UIViewController) {
        
        mainPanelObserves.removeAll()
        
        mainPanelVC = FloatingPanelController()
        mainPanelVC?.delegate = self
        mainPanelVC?.modalPresentationStyle = .overFullScreen
        mainPanelVC?.setVibrancyAlpha(withValue: 0.95)
        mainPanelVC?.surfaceView.cornerRadius_ = 10.0
        mainPanelVC?.surfaceView.shadowHidden = false
        mainPanelVC?.surfaceView.grabberHandle.isHidden = true
        mainPanelVC?.isRemovalInteractionEnabled = false
        
        let helper = ForeUpdateHelper()
        let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
        helper.controller = controller
        
        //        let controller = getForceUpdateView()
        mainPanelVC?.set(contentViewController: controller)
        
        mainPanelVC?.addPanel(toParent: on, belowView: nil, animated: true)
        mainPanelVC?.updateLayout()
        
    }
    
    func getForceUpdateView() -> UIViewController {
        
        let viewController = UIViewController()
        
        let view = UIView()
        //        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        var rect = viewController.view.frame
        rect.size.height = 550
        view.frame = rect
        viewController.view.addSubview(view)
        
        view.showEmptyState(withTitle: NSAttributedString(string: "New Day, New Version"), description: NSAttributedString(string: "You need the latest app version to go to Blibli.com and continue shopping. Update now to get back in style!"), image: UIImage(named: "empty_cart") , buttonTitle: NSAttributedString(string: "Update Now"), completion: { (_) in
            
        })
        
        return viewController
    }
    
    func floatingPanel(_ vc: FloatingPanelController, shouldRecognizeSimultaneouslyWith gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public var initialPosition: FloatingPanelPosition {
        return .full
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return 150.0
        case .half:
            return 50.0
        case .tip, .hidden: return 0.0
        }
    }
    
    public func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        switch position {
        case .half:
            return 0.5
        default:
            return 0.0
        }
    }
}

enum ValidationType: String {
    case email = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
    case phone = "^((\\+)|(00))[0-9]{6,14}$"
    case name = "[A-Za-z\\s]+"
    case password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,}"
}

extension String {
    
    func validate(type:ValidationType) -> Bool {
        do {
            if try NSRegularExpression(pattern: type.rawValue, options: .caseInsensitive).firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) == nil {
                return false
            }
        } catch {
            return false
        }
        return true
    }
    
    func validate(_ regexString: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexString)
        return predicate.evaluate(with: self)
    }
}
