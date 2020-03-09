//
//  PagerViewLandingController.swift
//  Demo
//
//  Created by RONAK GARG on 30/05/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import CommonUIKit

class PagerViewLandingController: UIViewController {

    @IBAction func openPageViewDidTapped(_ sender: Any) {
        let helper = CustomPagerViewController()
        let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
        helper.controller = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
