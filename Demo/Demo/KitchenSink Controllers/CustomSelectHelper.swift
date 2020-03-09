//
//  CustomSelectHelper.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 24/04/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit
import CommonUIKit

public protocol CustomSelectHelperDelegate: class {
    func didTapCustomSelect(sender: CustomSelectHelper)
}

public extension CustomSelectHelperDelegate { 
    func didTapCustomSelect(sender: CustomSelectHelper) {}
}

public class CustomSelectHelper: NSObject, CommonTableViewDelegate, CommonTableViewDataSource {
    
    public var datasource: [CustomSelectModel] = []
    public var controller : CommonTableViewController!
    
    public weak var delegate: CustomSelectHelperDelegate?
    
    public var horizontalPosition: Position = Position.left
    
    public func navigationTitle() -> String {
        return "Custom Select"
    }
    
    public func shouldShowSeparatorLine() -> Bool {
        return true
    }
    
    public func customBackButton() -> UIImage? {
        return UIImage(named: "back", in: Bundle(for: CustomSelect.self), compatibleWith: nil)
    }
    
    public func handleEvent(withControllerLifeCycle event: ViewControllerLifeCycleEvents, viewController: CommonTableViewController, otherInfo: [String : Any]?) {
        viewController.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public func reusableIdentifiers() -> [String]? {
        return ["CustomSelect", "CustomSelectRight"]
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if horizontalPosition == Position.left  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSelect", for: indexPath) as? BaseTableViewCell,
                let customView = cell.customView as? CustomSelect else {
                    return UITableViewCell()
            }
            
            customView.delegate = self
            
            let customSelectConfig = datasource[indexPath.row]
            customView.indexPath = indexPath
            customView.tag = indexPath.row
            customView.text = customSelectConfig.text
            customView.attributedText = customSelectConfig.attributedText
            customView.horizontalAlignment = customSelectConfig.horizontalAlignment
            customView.verticalAlignment = customSelectConfig.verticalAlignment
            customView.selectionMode = customSelectConfig.selectionMode
            customView.isEnabled = customSelectConfig.isEnabled
            customView.selectType = customSelectConfig.selectType
            
            if customSelectConfig.isEnabled {
                customView.imageTintColor = UIColor(hexString: "#bdbdbd")
            } else {
                customView.selectionMode = .selected
                customView.selectedImageTintColor = UIColor(hexString: "#e0e0e0")
                customView.textColor = UIColor.black.withAlphaComponent(0.38)
            }
            return cell
        } else if horizontalPosition == Position.right {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSelectRight", for: indexPath) as? BaseTableViewCell,
                let customView = cell.customView as? CustomSelectRight else {
                    return UITableViewCell()
            }
            
            customView.delegate = self
            
            let customSelectConfig = datasource[indexPath.row]
            customView.indexPath = indexPath
            customView.tag = indexPath.row
            customView.text = customSelectConfig.text
            customView.attributedText = customSelectConfig.attributedText
            customView.horizontalAlignment = customSelectConfig.horizontalAlignment
            customView.verticalAlignment = customSelectConfig.verticalAlignment
            customView.selectionMode = customSelectConfig.selectionMode
            customView.isEnabled = customSelectConfig.isEnabled
            customView.selectType = customSelectConfig.selectType
            
            if customSelectConfig.isEnabled {
                customView.imageTintColor = UIColor(hexString: "#bdbdbd")
            } else {
                customView.selectionMode = .selected
                customView.selectedImageTintColor = UIColor(hexString: "#e0e0e0")
                customView.textColor = UIColor.black.withAlphaComponent(0.38)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    public func viewSetup(customView: UIView) {
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public func showCustomSelect(withHelper helper: CustomSelectHelper) {
        DispatchQueue.main.async {
            let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
            helper.controller = controller
            //helper.completionHandler = completionHandler
            UIApplication.topMost?.show(controller, sender: self) //present(controller, animated: true, completion: nil)
        }
    }
}

//MARK:- Custom Select Delegate

extension CustomSelectHelper: CustomSelectDelegate {
    
    public func didTapCustomSelect(sender: CustomSelect) {
        
        if let indexPath = sender.indexPath, let cell = self.controller?.tableview.cellForRow(at: indexPath) as? BaseTableViewCell, let customView = cell.customView as? CustomSelect {
            
            //If it is a single select, deselect the already selected options
            
            if sender.selectType == .single, customView.selectionMode != .selected {
                for (index, source) in datasource.enumerated() {
                    if source.selectionMode == .selected, let cell_ = controller?.tableview.cellForRow(at: IndexPath(row: index, section: 0)) as? BaseTableViewCell, let customView_ = cell_.customView as? CustomSelect {
                        customView_.selectionMode = .unselected
                        source.selectionMode = .unselected
                    }
                }
            }
            
            
            //If it is a single select, we should not deselect the already selected option when we tap onto the same option again
            
            if customView.selectionMode == .unselected {
                customView.selectionMode = .selected
                datasource[indexPath.row].selectionMode = .selected
            } else if sender.selectType != .single {
                customView.selectionMode = .unselected
                datasource[indexPath.row].selectionMode = .unselected
            }
            
            delegate?.didTapCustomSelect(sender: self)
        }
    }
}


//MARK:- Custom Select Right Delegate

extension CustomSelectHelper: CustomSelectRightDelegate {
    
    public func didTapCustomSelect(sender: CustomSelectRight) {
        
        if let indexPath = sender.indexPath, let cell = self.controller?.tableview.cellForRow(at: indexPath) as? BaseTableViewCell, let customView = cell.customView as? CustomSelectRight {
            
            //If it is a single select, deselect the already selected options
            
            if sender.selectType == .single, customView.selectionMode != .selected {
                for (index, source) in datasource.enumerated() {
                    if source.selectionMode == .selected, let cell_ = controller?.tableview.cellForRow(at: IndexPath(row: index, section: 0)) as? BaseTableViewCell, let customView_ = cell_.customView as? CustomSelectRight {
                        customView_.selectionMode = .unselected
                        source.selectionMode = .unselected
                    }
                }
            }
            
            
            //If it is a single select, we should not deselect the already selected option when we tap onto the same option again
            
            if customView.selectionMode == .unselected {
                customView.selectionMode = .selected
                datasource[indexPath.row].selectionMode = .selected
            } else if sender.selectType != .single {
                customView.selectionMode = .unselected
                datasource[indexPath.row].selectionMode = .unselected
            }
            
            delegate?.didTapCustomSelect(sender: self)
        }
    }
}
