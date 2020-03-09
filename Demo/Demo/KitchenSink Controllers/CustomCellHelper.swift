//
//  CustomCellHelper.swift
//  Demo
//
//  Created by Rajadorai DS on 17/06/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import Foundation
import CommonUIKit

public protocol CustomCellHelperDelegate: class {
    func didTapCustomCell(sender: CustomCellHelper)
}

public extension CustomCellHelperDelegate {
    func didTapCustomSelect(sender: CustomCellHelper) {}
}

public class CustomCellHelper: NSObject, CommonTableViewDelegate, CommonTableViewDataSource {
   
    public var datasource: [CustomCellModel] = []
    public var controller: CommonTableViewController!
    
    public weak var delegate: CustomCellHelperDelegate?

    public func navigationTitle() -> String {
        return "List"
    }
    
    public func shouldShowSeparatorLine() -> Bool {
        return true
    }
    
    public func customBackButton() -> UIImage? {
        return UIImage(named: "back", in: Bundle(for: CustomCell.self), compatibleWith: nil)
    }
    
    
    public func handleEvent(withControllerLifeCycle event: ViewControllerLifeCycleEvents, viewController: CommonTableViewController, otherInfo: [String : Any]?) {
        viewController.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public func reusableIdentifiers() -> [String]? {
        return ["CustomCell"]
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? BaseTableViewCell,
            let customView = cell.customView as? CustomCell else {
                return UITableViewCell()
        }
        
        customView.delegate = self
        let customSelectConfig = datasource[indexPath.row]
        customView.indexPath = indexPath
        customView.tag = indexPath.row
        customView.titleText = customSelectConfig.title
        customView.detailText = customSelectConfig.detail
        customView.buttonImage = customSelectConfig.buttonImage
        customView.listImage = customSelectConfig.listImage
        customView.imageVerticalAlignment = customSelectConfig.imageVerticalAlignment
        customView.buttonVerticalAlignment = customSelectConfig.buttonVerticalAlignment
        customView.textColor = UIColor.black.withAlphaComponent(0.38)
        cell.selectionStyle = .none
        return cell
    }
    
    
    public func showCustomCell(withHelper helper: CustomCellHelper) {
        DispatchQueue.main.async {
            let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
            helper.controller = controller
            UIApplication.topMost?.show(controller, sender: self)
        }
    }

    
}


extension CustomCellHelper: CustomCellDelegate {
    public func didTapCustomCell(sender: CustomCell) {
    }
    
}
