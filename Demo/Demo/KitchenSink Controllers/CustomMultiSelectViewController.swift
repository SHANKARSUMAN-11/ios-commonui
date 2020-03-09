//
//  CustomMultiSelectViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 23/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomMultiSelectViewController: UIViewController {
    
    @IBOutlet weak var multiSelectButton: CustomButton!
    @IBOutlet weak var singleSelectButton: CustomButton!
    @IBOutlet weak var switchView: UIView!
    
    var customSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        customSwitch.onTintColor = UIColor(hexString: "#4db1f9")
        customSwitch.offTintColor = UIColor(hexString: "#d6d6d6")
        customSwitch.padding = 4.0
        customSwitch.thumbSize = CGSize(width: 23.0, height: 23.0)
        customSwitch.thumbTintColor = UIColor.white
        customSwitch.animationDuration = 0.25
        customSwitch.isOn = true
        return customSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchView.addSubview(customSwitch)
        customSwitch.addTarget(self, action: #selector(handleSwitch(toggle:)), for: .valueChanged)
        setupConstraints()
    }
    
    @objc func handleSwitch(toggle: CustomSwitch) {
        toggle.setOn(on: true, animated: false)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            customSwitch.topAnchor.constraint(equalTo: switchView.topAnchor),
            customSwitch.centerXAnchor.constraint(equalTo: switchView.centerXAnchor),
            customSwitch.widthAnchor.constraint(equalToConstant: switchView.frame.width),
            customSwitch.heightAnchor.constraint(equalToConstant: switchView.frame.height)])
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        
        let horizontalPosition: Position = Position.right
        
        let model1 = CustomSelectModel(withText: "Option 1", selectType: .single, horizontalAlignment: horizontalPosition)
        
        let model2 = CustomSelectModel(withText: "Option 2", selectType: .single, selectionMode: .selected, horizontalAlignment: horizontalPosition, verticalAlignment: .top)
        
        let model3 = CustomSelectModel(withText: "Option 3", selectType: .single, horizontalAlignment: horizontalPosition)
        
        let model4 = CustomSelectModel(withText: "Option 4", selectType: .single, horizontalAlignment: horizontalPosition, isEnabled: false)
        
        
        let customSelectHelper = CustomSelectHelper()
        customSelectHelper.datasource = [model1, model2, model3, model4]
        customSelectHelper.delegate = self
        customSelectHelper.horizontalPosition = horizontalPosition
        customSelectHelper.showCustomSelect(withHelper: customSelectHelper)
    }
    
    @IBAction func didTapMultiSelectButton(_ sender: Any) {
        
        let horizontalPosition: Position = Position.left
        
        let model1 = CustomSelectModel(withText: "Multi select option 1 ", selectType: .multiple, horizontalAlignment: horizontalPosition)
        
        let model2 = CustomSelectModel(withText: "Multi select option 2", selectType: .multiple, selectionMode: .selected, horizontalAlignment: horizontalPosition, verticalAlignment: .top)
        
        let model3 = CustomSelectModel(withText: "Multi select option 3", selectType: .multiple, horizontalAlignment: horizontalPosition)
        
        let model4 = CustomSelectModel(withText: "Multi select option 4", selectType: .multiple, horizontalAlignment: horizontalPosition, isEnabled: false)
        
        let customSelectHelper = CustomSelectHelper()
        customSelectHelper.datasource = [model1, model2, model3, model4]
        customSelectHelper.delegate = self
        customSelectHelper.horizontalPosition = horizontalPosition
        customSelectHelper.showCustomSelect(withHelper: customSelectHelper)
    }
}

extension CustomMultiSelectViewController: CustomSelectDelegate {
    
    func didTapCustomSelect(sender: CustomSelect) {
        /*
         if sender == multiSelect1 {
         
         if multiSelect1.selectionMode == .unselected {
         multiSelect1.selectionMode = .selected
         } else {
         multiSelect1.selectionMode = .unselected
         }
         }*/
    }
}

extension CustomMultiSelectViewController: CustomSelectHelperDelegate {
    
    func didTapCustomSelect(sender: CustomSelectHelper) {
        // Do your stuff here
    }
}
