//
//  ForceUpdate.swift
//  BlibliMobile-iOS
//
//  Created by Ashok Kumar on 06/08/19.
//  Copyright © 2019 Global Digital Niaga, PT. All rights reserved.
//

import UIKit
import CommonUIKit

class ForceUpdate: UIViewController {
    
    var mainPanelObserves: [NSKeyValueObservation] = []
    var mainPanelVC: FloatingPanelController?
    var presenter = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @objc func didTapButton() {
        show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.center = self.view.center
        button.sizeToFit()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    func show() {

        self.showSheet()
        return
        
        if let topController = UIApplication.topMost {
            self.presenter = UIViewController()
            self.presenter.view.backgroundColor = .clear
            self.presenter.modalPresentationStyle = .overFullScreen
            topController.present(presenter, animated: false, completion: {
                self.showSheet()
            })
        }
    }
    
    func showSheet() {
        
        //if let topController = UIApplication.topMost {
            
            if let mainPanelVC = self.mainPanelVC {
                mainPanelVC.removePanelFromParent(animated: true) {
                    self.showForceUpdatePopup(on: self)
                }
            } else {
                self.showForceUpdatePopup(on: self)
            }
            
        //}
    }
    
    func showForceUpdatePopup(on: UIViewController) {
        
//        mainPanelObserves.removeAll()
        
        mainPanelVC = FloatingPanelController()
        mainPanelVC?.delegate = self
        mainPanelVC?.modalPresentationStyle = .overFullScreen
        mainPanelVC?.setVibrancyAlpha(withValue: 0.95)
        mainPanelVC?.surfaceView.cornerRadius_ = 10.0
        mainPanelVC?.surfaceView.shadowHidden = false
        mainPanelVC?.surfaceView.grabberHandle.isHidden = true
        mainPanelVC?.isRemovalInteractionEnabled = false
        
        let helper = ForeUpdateHelper()
//        let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
//        controller.tableview.estimatedRowHeight = 500.0
//        helper.controller = controller
        
        let controller = getForceUpdateView()
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
}

class ForeUpdateHelper: NSObject, CommonTableViewDelegate, CommonTableViewDataSource {
    
    var controller: CommonTableViewController?
    
    func shouldShowSeparatorLine() -> Bool {
        return false
    }
    
    func reusableIdentifiers() -> [String]? {
        return ["EmptyStateBackgroundView"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateBackgroundView", for: indexPath) as? BaseTableViewCell,
            let customView = cell.customView as? EmptyStateBackgroundView else {
                return UITableViewCell()
        }
        
        customView.title = NSAttributedString(string: "New Day, New Version")
        customView.message = NSAttributedString(string: "You need the latest app version to go to Blibli.com and continue shopping. Update now to get back in style!")
        customView.image = UIImage(named: "empty_cart")
        customView.buttonTitle = NSAttributedString(string: "Update Now")
        
        return cell
    }
}

//MARK:- Floating Panel delegate methods

extension ForceUpdate: FloatingPanelControllerDelegate, FloatingPanelLayout {
    
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
