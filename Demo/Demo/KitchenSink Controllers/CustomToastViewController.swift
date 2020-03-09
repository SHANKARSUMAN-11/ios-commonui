//
//  CustomToastViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 05/05/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomToastViewController: UIViewController, CustomButtonDelegate {

    @IBOutlet weak var containedButton: CustomButton!
    @IBOutlet weak var outlineButton: CustomButton!
    @IBOutlet weak var ghostButton: CustomButton!
    @IBOutlet weak var containedImageButton: CustomButton!
    @IBOutlet weak var outlinedImageButton: CustomButton!
    @IBOutlet weak var ghostImageButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
    }
    
    func setupButtons() {
        containedButton.setButton(withTitle: "Single Line Toast", image: nil, type: .contained)
        containedButton.tag = 0
        outlineButton.setButton(withTitle: "Multi Line Toast", image: nil, type: .outlined)
        outlineButton.tag = 1
        ghostButton.setButton(withTitle: "Auto Dismiss Toast", image: nil, type: .ghost)
        ghostButton.tag = 2
        
        containedImageButton.setButton(withTitle: "Single Line with Action", image: nil, type: .contained)
        containedImageButton.tag = 3
        outlinedImageButton.setButton(withTitle: "Multi Line with Action", image: nil, type: .outlined)
        outlinedImageButton.tag = 4
        ghostImageButton.setButton(withTitle: "Auto Dismiss with Action", image: nil, type: .ghost)
        ghostImageButton.tag = 5
        
        containedButton.delegate = self
        outlineButton.delegate = self
        ghostButton.delegate = self
        containedImageButton.delegate = self
        outlinedImageButton.delegate = self
        ghostImageButton.delegate = self
    }
    
    func didTapButton(sender: Any) {
        
        if let sender_ = sender as? CustomButton {
            
            self.view.hideAllToasts()
            let toastManager = ToastManager.shared
            var style = toastManager.style
            style.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            style.buttonFont = UIFont(name: "EffraMedium-Regular", size: 14.0) ?? .systemFont(ofSize: 14.0)
            style.displayShadow = true
            style.titleFont = UIFont(name: "Effra-Regular", size: 14.0) ?? .systemFont(ofSize: 14.0)
            style.messageFont = UIFont(name: "Effra-Regular", size: 14.0) ?? .systemFont(ofSize: 14.0)
            style.buttonColor = UIColor(hexString: "#0095da")
            style.shadowOpacity = 0.48
            
            switch sender_.tag {
            case 0:
                toastManager.shouldAutoDismiss = false
                self.view.makeToast("Single line message with no action.", duration: 2.0, style: style, completion: nil)
            case 1:
                toastManager.shouldAutoDismiss = false
                self.view.makeToast("Your catchy text goes here and multi-line message with no action.", duration: 2.0, style: style, completion: nil)
            case 2:
                toastManager.shouldAutoDismiss = true
                self.view.makeToast("Auto Dismiss Toast (2 secs)", duration: 2.0, style: style, completion: nil)
            case 3:
                toastManager.shouldAutoDismiss = false
                self.view.makeToast("Single line with action.", duration: 2.0, buttonTitle: "Click Me", style: style, completion: nil)
            case 4:
                toastManager.shouldAutoDismiss = false
                self.view.makeToast("Your catchy text goes here and two-line message with action.", duration: 2.0, buttonTitle: "Click Me", style: style, completion: nil)
            case 5:
                toastManager.shouldAutoDismiss = true
                self.view.makeToast("Auto Dismiss Toast (2 secs) with action.", duration: 2.0, buttonTitle: "Click Me", style: style, completion: nil)
            default:
                break
            }
        }
    }
}
