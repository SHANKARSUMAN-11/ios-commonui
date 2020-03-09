//
//  CustomXLPagerHelper.swift
//  Demo
//
//  Created by Rahul Pengoria on 31/07/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomXLPagerHelper: CustomXLPagerViewDataSource, SegmentControlViewDecoratorDelegate, CustomXLPagerViewDelegate {
    func configure(for: CustomXLPager?) -> CustomXLPagerConfig {
        let config = CustomXLPagerConfig()
        config.selectedIndex = 0
        config.backgroungColorForCustomXLPager = .groupTableViewBackground
        config.fixedSegmentWidth = true
        config.heightForSegmentedControl = 70
        config.containerViewEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        config.segmentControlEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        config.pageViewEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        config.shadowColor = UIColor.red.cgColor
        config.shadowRadius = 5.0
        config.cornerRadius = 5.0
        config.shadowOpacity = 0.2
        /// Configure the underline below the selected tab
//        config.underlineConfig.showUnderLine = false
//        config.underlineConfig.backgroundColor = .white
//        config.underlineConfig.heightOfSelectedTabUnderline = 10
//        config.underlineConfig.animationDuration = 1.0
        return config
    }
    
    func didFinishTransition(for: CustomXLPager, selectedController: UIViewController?, pageIndex: Int) {
        print("\(pageIndex)")
    }
    
    func handleEvent(withControllerLifeCycle event: ViewControllerLifeCycleEvents, viewController: CustomXLPager, otherInfo: [String : Any]?) {
        if event == .didLoad {
            print("\(String(describing: viewController.activeController()))")
        }
        
    }
    
    //Uncomment this for custom view demo
    
//    func customView(for: ScrollableSegmentedControl?, in: CustomXLPager) -> ScrollableSegmentedControl? {
//        let embeddedGradientSegmentControl = ScrollableSegmentedControl()
//
//        embeddedGradientSegmentControl.insertSegment(withTitle: "Tab 1", at: 0)
//        embeddedGradientSegmentControl.insertSegment(withTitle: "Tab 2", at: 1)
//        embeddedGradientSegmentControl.insertSegment(withTitle: "Tab 3", at: 2)
//        embeddedGradientSegmentControl.insertSegment(withTitle: "Tab 4", at: 3)
//        embeddedGradientSegmentControl.insertSegment(withTitle: "Tab 5", at: 4)
//        embeddedGradientSegmentControl.insertSegment(withTitle: "Tab 6", at: 5)
//        embeddedGradientSegmentControl.insertSegment(withTitle: "Tab 7", at: 6)
//        embeddedGradientSegmentControl.insertSegment(withTitle: "Tab 8", at: 7)
//        embeddedGradientSegmentControl.insertSegment(withTitle: "Tab 9", at: 8)
//        
//        
//        embeddedGradientSegmentControl.selectedSegmentIndex = 0
//        embeddedGradientSegmentControl.underlineSelected = true
//        embeddedGradientSegmentControl.tintColor = UIColor.clear
//        embeddedGradientSegmentControl.segmentContentColor = UIColor.black.withAlphaComponent(0.68)
//        embeddedGradientSegmentControl.selectedSegmentContentColor = UIColor.white
//        embeddedGradientSegmentControl.backgroundColor = UIColor.orange
//        embeddedGradientSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Effra-Regular", size: 16.0) as Any], for: .normal)
//        embeddedGradientSegmentControl.viewDecoratorDelegate = self
//        return embeddedGradientSegmentControl
//    }
    
    func setup(cell: UICollectionViewCell, indexPath: IndexPath) {
        if let textCell = cell as? ScrollableSegmentedControl.TextOnlySegmentCollectionViewCell {
            let colors = [UIColor(hexString: "#f8a33f"), UIColor(hexString: "#f37021")]
            if textCell.isSelected {
                textCell.setGradient(with: colors, from: CGPoint(x: 0.0, y: 1.0), to: CGPoint(x: 1.0, y: 1.0))
            } else {
                if let gradientLayer = cell.layer.sublayers?.first as? CAGradientLayer {
                    gradientLayer.removeFromSuperlayer()
                }
                textCell.backgroundColor = UIColor(hexString: "#f1f1f1")
            }
            textCell.clipsToBounds = true
            let height = textCell.frame.height
            textCell.layer.cornerRadius = (height/2)
        }
    }
    
    func didDeselect(cell: UICollectionViewCell, indexPath: IndexPath) {
        if let gradientLayer = cell.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    func didSelect(cell: UICollectionViewCell, indexPath: IndexPath) {
        cell.setGradient(with: [UIColor(hexString: "#f8a33f"), UIColor(hexString: "#f37021")], from: CGPoint(x: 0.0, y: 1.0), to: CGPoint(x: 1.0, y: 1.0))
        
    }
    
    func style(for: ScrollableSegmentedControl?, in: CustomXLPager) -> ScrollableSegmentedControlSegmentStyle {
        return .imageOnTop
    }
    
    func title(for: ScrollableSegmentedControl?, in: CustomXLPager) -> [String]? {
        return ["Tab 1", "Tab 2", "Tab 3", "Tab 4", "Tab 5", "Tab 6", "Tab 7", "Tab 8", "Tab 9"]
    }
    
    func images(for: ScrollableSegmentedControl?, in: CustomXLPager) -> [UIImage]? {
        return [#imageLiteral(resourceName: "assignment"), #imageLiteral(resourceName: "language"), #imageLiteral(resourceName: "help")]
    }
    
    func attributes(for: ScrollableSegmentedControl?) -> SegementedControlAttributes {
        let value = SegementedControlAttributes()
        value.segementedControlTintColor = UIColor(hexString: "#0095da")
        value.segmentContentColor = .black
        value.selectedSegmentContentColor = UIColor(hexString: "#0095da")
        value.backgroundColor = .orange
        return value
    }
    
    func controllers(for: CustomXLPager) -> [UIViewController] {
        let helper = CustomPagerViewController()
        let controller1 = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
        helper.controller = controller1
        
        let helper1 = TestTableViewController()
        let controller2 = CommonTableViewController.instantiate(dataSource: helper1, delegate: helper1)
        let controller3 = CommonTableViewController.instantiate(dataSource: helper1, delegate: helper1)
        let controller4 = CommonTableViewController.instantiate(dataSource: helper1, delegate: helper1)
        let controller5 = CommonTableViewController.instantiate(dataSource: helper1, delegate: helper1)
        let controller6 = CommonTableViewController.instantiate(dataSource: helper1, delegate: helper1)
        let controller7 = CommonTableViewController.instantiate(dataSource: helper1, delegate: helper1)
        let controller8 = CommonTableViewController.instantiate(dataSource: helper1, delegate: helper1)
        let controller9 = CommonTableViewController.instantiate(dataSource: helper1, delegate: helper1)
        
        return [controller1, controller2, controller3,controller4, controller5, controller6, controller7, controller8, controller9]
        
    }
    
    
}


class TestTableViewController: NSObject, CommonTableViewDataSource, CommonTableViewDelegate {
    
    func shouldShowSeparatorLine() -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func reusableIdentifiersForSimpleTableViewCell() -> [String]? {
        return ["cellDetail"]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail") else {
            return UITableViewCell()
        }
        cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cellDetail")
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.text = "cell \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let helper = CustomPagerViewController()
        let controller1 = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
        
        UIApplication.topMost?.navigationController?.pushViewController(controller1, animated: true)
    }
    
}

