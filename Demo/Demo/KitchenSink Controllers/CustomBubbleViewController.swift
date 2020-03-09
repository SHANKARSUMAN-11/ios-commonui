//
//  CustomBubbleViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 14/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomBubbleViewController: UIViewController {

    @IBOutlet weak var defaultBubble: CustomBubble!
    @IBOutlet weak var defaultSelectedBubble: CustomBubble!
    @IBOutlet weak var outlineBubble: CustomBubble!
    @IBOutlet weak var outlineSelectedBubble: CustomBubble!
    @IBOutlet weak var inputBubble: CustomBubble!
    @IBOutlet weak var inputOutlineBubble: CustomBubble!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBubble()
    }

    func setupBubble() {
        let component = Configuration.shared.getComponent()?.Bubble
        
        defaultBubble.setMainButtonTitle("Default", titleColor: component?.getTextColor())
        defaultBubble.setBackgroundColor(color: UIColor(hexString: "#f1f1f1"))
        
        defaultSelectedBubble.setMainButtonTitle("Default Selected", titleColor: component?.getSelectedTextColor())
        defaultSelectedBubble.setBackgroundColor(color: UIColor(hexString: "#0095da"))
        
        outlineBubble.setMainButtonTitle("Outline", titleColor: component?.getTextColor())
        outlineBubble.setBackgroundColor(color: UIColor(hexString: "#ffffff"))
        
        outlineSelectedBubble.setMainButtonTitle("Outline Selected", titleColor: UIColor(hexString: "#0095da"))
        outlineSelectedBubble.setBackgroundColor(color: UIColor(hexString: "#daf3ff"))
        
        inputBubble.setLeftButtonImage(withImageName: UIImage(named: "favorite"), imageColor: UIColor.gray)
        inputBubble.setRightButtonImage(withImageName: UIImage(named: "error"), imageColor: UIColor.gray)
        inputBubble.setMainButtonTitle("Input Chip", titleColor: component?.getTextColor())
        inputBubble.setBackgroundColor(color: UIColor(hexString: "#f1f1f1"))
        
        inputOutlineBubble.setLeftButtonImage(withImageName: UIImage(named: "favorite"), imageColor: UIColor.gray)
        inputOutlineBubble.setRightButtonImage(withImageName: UIImage(named: "error"), imageColor: UIColor.gray)
        inputOutlineBubble.setMainButtonTitle("Input Outline Chip", titleColor: component?.getTextColor())
        inputOutlineBubble.setBackgroundColor(color: UIColor(hexString: "#ffffff"))
    }
}
