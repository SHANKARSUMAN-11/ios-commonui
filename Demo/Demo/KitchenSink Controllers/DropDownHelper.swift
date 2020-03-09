//
//  DropDownHelper.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 10/04/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit
import CommonUIKit

public class DropDownHelper: NSObject, CommonTableViewDataSource, CommonTableViewDelegate {
    
    public static let shared = DropDownHelper()
    public weak var controller : CommonTableViewController?
    public var dropdownTitle: String? = nil
    public var datasource: [CustomSelectModel] = []
    public var selectType: SelectType = .single
    public var itemHeight: CGFloat = 64.0
    public var mainPanelVC: FloatingPanelController!
    var presenter = UIViewController()
    public var mainPanelObserves: [NSKeyValueObservation] = []
    public weak var presentingController: UIViewController?
    
    public func shouldShowSeparatorLine() -> Bool {
        return true
    }

    public func reusableNibsIdentifier() -> [String]? {
        return ["DropDownTableViewCell"]
    }
    
    func getHeaderHeight() -> CGFloat {
        if dropdownTitle != nil {
            return itemHeight - 15.0
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return getHeaderHeight()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: itemHeight))
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect.init(x: 15.0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.text = dropdownTitle
        label.font = UIFont(name: "EffraMedium-Regular", size: 16.0)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.38)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight //UITableView.automaticDimension
    }
 
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as? DropDownTableViewCell else {
                return UITableViewCell()
        }

        let data = datasource[indexPath.row]
        
        cell.customSelect.backgroundColor = UIColor.clear
        cell.customSelect.delegate = self
        cell.customSelect.indexPath = indexPath
        cell.customSelect.selectType = data.selectType
        cell.customSelect.horizontalAlignment = data.horizontalAlignment
        cell.customSelect.text = data.text
//        cell.customSelect.setImage(withImage: UIImage(named: "right_arrow", in: Bundle.main, compatibleWith: nil), tintColor: UIColor.gray)
        cell.backgroundView_.backgroundColor = (data.selectionMode == .selected) ? UIColor(hexString: "#daf3ff") : UIColor.white
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
}

//MARK:- Panel helper

public extension DropDownHelper {
    
    public func addPanel(with helper: DropDownHelper, controller: CommonTableViewController, to: UIViewController) {
        
        presentingController = to
        
        if let mainPanelVC = mainPanelVC {
            mainPanelVC.removePanelFromParent(animated: true) {
                self.addMainPanel(with: helper, controller: controller, to: to)
            }
        } else {
            addMainPanel(with: helper, controller: controller, to: to)
        }
    }
    
    public func addMainPanel(with helper: DropDownHelper, controller: CommonTableViewController, to: UIViewController) {
        mainPanelObserves.removeAll()
        
        // Initialize FloatingPanelController
        mainPanelVC = FloatingPanelController()
        mainPanelVC.delegate = self
        
        // Initialize FloatingPanelController and add the view
        mainPanelVC.setVibrancyAlpha(withValue: 0.9)
        mainPanelVC.surfaceView.cornerRadius_ = 6.0
        mainPanelVC.modalPresentationStyle = .overFullScreen
        
        //mainPanelVC.track(scrollView: contentVC.tableView)
        
        // Set a content view controller
        mainPanelVC.set(contentViewController: controller)
        
        mainPanelVC.isRemovalInteractionEnabled = false
        
        let backdropTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackdrop(tapGesture:)))
        mainPanelVC.backdropView.addGestureRecognizer(backdropTapGesture)
        
        if let tableView = helper.controller?.tableview {
            
            let ob = tableView.observe(\.isEditing) { (tableView, _) in
                self.mainPanelVC.panGestureRecognizer.isEnabled = !tableView.isEditing
            }
            mainPanelObserves.append(ob)
            mainPanelVC.track(scrollView: helper.controller?.tableview)
        }
 
        //self.mainPanelVC.addPanel(toParent: to, belowView: nil, animated: true)
        //self.mainPanelVC.updateLayout()
        
        
        if let topController = UIApplication.topMost {
            presenter = UIViewController()
            presenter.view.backgroundColor = .gray
            presenter.modalPresentationStyle = .overFullScreen
            topController.present(presenter, animated: false, completion: {
                self.mainPanelVC.addPanel(toParent: self.presenter, belowView: nil, animated: true)
                self.mainPanelVC.updateLayout()
            })
        }
    }
    
    @objc func handleBackdrop(tapGesture: UITapGestureRecognizer) {
        switch tapGesture.view {
        case mainPanelVC.backdropView:
            if mainPanelVC.position == .full || mainPanelVC.position == .half {
                
                //If the Floating Panel supports .tip position, move the sheet to .tip position. Uncomment the following line and comment the removePanel block in the next line
                mainPanelVC.move(to: .tip, animated: true)
                
                //If the .tip position is not supported, directly remove the panel from the parent
                //mainPanelVC.removePanelFromParent(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

extension DropDownHelper: FloatingPanelControllerDelegate, FloatingPanelLayout {
    
    public func floatingPanelDidDragGrabberHandle(_ vc: FloatingPanelController, isSwipeDown: Bool) {
        
        if isSwipeDown, (mainPanelVC.position == .full || mainPanelVC.position == .half) {
            //If the Floating Panel supports .tip position, move the sheet to .tip position. Uncomment the following line and comment the removePanel block in the next line
            mainPanelVC.move(to: .tip, animated: true)
            
            //mainPanelVC.removePanelFromParent(animated: true, completion: nil)
            //presenter.dismiss(animated: true, completion: nil)
            
        } else {
            //mainPanelVC.removePanelFromParent(animated: true, completion: nil)
        }
    }
    
    public func floatingPanelShouldBeginDragging(_ vc: FloatingPanelController) -> Bool {
        
        if vc.position == .tip {
            return true
        }
        
        let location = vc.panGestureRecognizer.location(in: vc.surfaceView)
        
        if vc.grabberFrame.contains(location) {
            return true
        }
        return false
    }
    
    public func floatingPanelDidChangePosition(_ vc: FloatingPanelController) {
        
        if vc.position == .tip {
            mainPanelObserves.removeAll()
            /*
            if let tableView = self.controller?.tableview {
                
                let ob = tableView.observe(\.isEditing) { (tableView, _) in
                    self.mainPanelVC.panGestureRecognizer.isEnabled = !tableView.isEditing
                }
                mainPanelObserves.append(ob)
                mainPanelVC.track(scrollView: self.controller?.tableview)
            }*/
        } else {
            mainPanelObserves.removeAll()
        }
    }
    
    public func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return (newCollection.verticalSizeClass == .compact) ? nil  : self
    }
    
    public func floatingPanel(_ vc: FloatingPanelController, shouldRecognizeSimultaneouslyWith gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public var initialPosition: FloatingPanelPosition {
        return .full
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }
    
    func getContentViewHeight(from controller: CommonTableViewController?) -> CGFloat? {
        return 440
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return 50.0
        case .half:
            return getContentViewHeight(from: self.controller)
        case .tip: return 70.0
        case .hidden: return 0.0
        }
    }
    
    public func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        switch position {
        case .full, .half:
            return 0.5
        default:
            return 0.0
        }
    }
}

extension DropDownHelper: CustomSelectDelegate {
    
    public func didTapCustomSelect(sender: CustomSelect) {
        
        if selectType == .single {
            
            for data in datasource {
                data.selectionMode = .unselected
            }
        }
        
        if let indexPath = sender.indexPath {
            datasource[indexPath.row].selectionMode = .selected
        }
        
        controller?.reloadData()
    }
}

extension DropDownHelper: CustomSelectRightDelegate {
    
    @objc(didTapCustomSelectWithSender:) public func didTapCustomSelect(sender: CustomSelectRight) {
        
        if selectType == .single {
            
            for data in datasource {
                data.selectionMode = .unselected
            }
        }
        
        if let indexPath = sender.indexPath {
            datasource[indexPath.row].selectionMode = .selected
        }
        
        controller?.reloadData()
    }
}
