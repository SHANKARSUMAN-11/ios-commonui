//
//  CommonWalkThroughHelper.swift
//  Demo
//
//  Created by Rahul Pengoria on 07/08/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CommonWalkThroughHelper: CommonWalkthroughControllerDataSource, CommonWalkthroughControllerDelegate  {
    func controllers(for: CommonWalkthroughController) -> [UIViewController] {
        let helper = CustomPagerViewController()
        let controller1 = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
        let helper1 = TestTableViewController()
        let helper3 = TestTableViewController()
        let controller2 = CommonTableViewController.instantiate(dataSource: helper1, delegate: helper1)
        let controller3 = CommonTableViewController.instantiate(dataSource: helper3, delegate: helper3)
            return [controller2, controller1 ,controller3]
    }
    
    func didFinishTransition(for: CommonWalkthroughController, with: UIViewController, prevButton: UIButton, nextButton: UIButton, pageIndex: Int) {
        
    }
    
    func shouldShowPageControl(for: CommonWalkthroughController) -> Bool {
        return true
    }
    
    func pageControl(for: CommonWalkthroughController) -> CommonWalkthroughPageControl {
        return CommonWalkthroughPageControl()
    }
    
    func shouldCreateTransitionButtons() -> Bool {
        return true
    }
    
    func position(for transitionButtons: (UIButton, UIButton)) -> (WalkthroughPosition, CGFloat) {
        return (.bottom, 0.0)
    }
    
    func didCreateTransitionButtons(previousButton: UIButton, nextButton: UIButton) {
        previousButton.backgroundColor = UIColor.blue
        nextButton.backgroundColor = UIColor.blue
        previousButton.setTitle("prev", for: .normal)
        nextButton.setTitle("next", for: .normal)
    }
    
    
    

}
