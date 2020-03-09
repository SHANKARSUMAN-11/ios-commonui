//
//  CustomTickerViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 14/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomTickerViewController: UIViewController {

    @IBOutlet weak var successTicker: CustomTicker!
    @IBOutlet weak var warningTicker: CustomTickerNew!
    @IBOutlet weak var infoTicker: CustomTicker!
    @IBOutlet weak var errorTicker: CustomTicker!
    @IBOutlet weak var defaultTicker: CustomTicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTicker()
    }
    
    func setupTicker() {
        
        successTicker.tickerType = .success
        successTicker.setLeftButtonImage(withImageName: "correct", imageColor: UIColor(hexString: "#abd673"))
        successTicker.titleText = NSAttributedString(string: "Title Goes Here")
        //successTicker.setDescription(description: "Type your content here and should be 1 lines with no links.")
        
        warningTicker.tickerType = .warning
        warningTicker.rightButtonWidth.constant = 70
        warningTicker.rightButton.setTitle("info", for: .normal)
        warningTicker.setLeftButtonImage(withImageName: "warning", imageColor: UIColor(hexString: "#eda654"))
        //warningTicker.rightButtonPosition = .top
        warningTicker.titleText = NSAttributedString(string: "Your content type here and should be 2 lines no links. Your content type here and should be 2 lines no links.")
        
        
        infoTicker.tickerType = .info
        infoTicker.setLeftButtonImage(withImageName: "info", imageColor: UIColor(hexString: "#65c1f9"))
        infoTicker.titleText = NSAttributedString(string: "Your content type here and should be 2 lines no links.")
        
        errorTicker.tickerType = .error
        errorTicker.setLeftButtonImage(withImageName: "error", imageColor: UIColor(hexString: "#dd4b49"))
        errorTicker.setRightButtonImage(withImageName: "close", imageColor: UIColor.darkGray)
        errorTicker.titleText = NSAttributedString(string: "Your content type here and should be 2 lines no links")
        
        defaultTicker.titleText = NSAttributedString(string: "Your content type here and should be 2 lines no links.")
 
    }

}
