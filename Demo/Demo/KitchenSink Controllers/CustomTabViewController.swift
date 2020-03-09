//
//  CustomTabViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 06/05/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomTabViewController: UIViewController {

    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var imageTextSegmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var imageSegmentedControl: ScrollableSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextSegmentedControl()
        setupImageSegmentedControl()
        setupSegmentedControl()
    }
    
    func setupTextSegmentedControl() {
        
        segmentedControl.insertSegment(withTitle: "Tab 1", at: 0)
        segmentedControl.insertSegment(withTitle: "Tab 2", at: 1)
        segmentedControl.insertSegment(withTitle: "Tab 3", at: 2)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.underlineSelected = true
        
        segmentedControl.tintColor = UIColor(hexString: "#0095da")
        segmentedControl.segmentContentColor = UIColor.black.withAlphaComponent(0.68)
        segmentedControl.selectedSegmentContentColor = UIColor(hexString: "#0095da")
        segmentedControl.backgroundColor = UIColor.white
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Effra-Regular", size: 16.0) as Any], for: .normal)
        
        segmentedControl.addTarget(self, action: #selector(changeTab), for: .valueChanged)
    }
    
    func setupImageSegmentedControl() {
        
        imageSegmentedControl.segmentStyle = .imageOnly
        imageSegmentedControl.insertSegment(with: #imageLiteral(resourceName: "assignment"), at: 0)
        imageSegmentedControl.insertSegment(with: #imageLiteral(resourceName: "language"), at: 1)
        imageSegmentedControl.insertSegment(with: #imageLiteral(resourceName: "help"), at: 2)
        
        imageSegmentedControl.selectedSegmentIndex = 1
        imageSegmentedControl.underlineSelected = true
        
        imageSegmentedControl.tintColor = UIColor(hexString: "#0095da")
        imageSegmentedControl.segmentContentColor = UIColor.black.withAlphaComponent(0.68)
        imageSegmentedControl.selectedSegmentContentColor = UIColor(hexString: "#0095da")
        
        imageSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Effra-Regular", size: 16.0) as Any], for: .normal)
    }
    
    func setupSegmentedControl() {
        
        imageTextSegmentedControl.segmentStyle = .imageOnTop
        imageTextSegmentedControl.insertSegment(withTitle: "Tab 1", image: #imageLiteral(resourceName: "assignment"), at: 0)
        imageTextSegmentedControl.insertSegment(withTitle: "Tab 2", image: #imageLiteral(resourceName: "language"), at: 1)
        imageTextSegmentedControl.insertSegment(withTitle: "Tab 3", image: #imageLiteral(resourceName: "help"), at: 2)
        
        imageTextSegmentedControl.selectedSegmentIndex = 2
        imageTextSegmentedControl.underlineSelected = true
        
        imageTextSegmentedControl.tintColor = UIColor(hexString: "#0095da")
        imageTextSegmentedControl.segmentContentColor = UIColor.black.withAlphaComponent(0.68)
        imageTextSegmentedControl.selectedSegmentContentColor = UIColor(hexString: "#0095da")
        
        imageTextSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Effra-Regular", size: 16.0) as Any], for: .normal)
    }
    
    @objc func changeTab() {
        //performSegue(withIdentifier: "TabbarController", sender: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TabbarController")
        self.show(controller, sender: nil)
    }

}
