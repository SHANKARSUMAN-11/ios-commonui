//
//  CustomDropDownViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 15/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomDropDownViewController: UIViewController, CustomButtonDelegate {
    
    @IBOutlet weak var customButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButton()
    }
    
    func setupButton() {
        customButton.setButton(withTitle: "Select Option", image: nil, type: .contained)
        customButton.tag = 0
        customButton.delegate = self
    }
    
    //MARK:- Custom Button Delegate
    
    func didTapButton(sender: Any) {
        showDropDown()
    }
    
    //MARK:- Drop Down Methods
    
    func showDropDown() {
        
        let model1 = CustomSelectModel(withText: "Option 1 to check whether the tableview is growing in its size if multiple lines of text is given")

        let model2 = CustomSelectModel(withText: "Option 2", selectionMode: .selected, verticalAlignment: .top)
        
        let model3 = CustomSelectModel(withText: "Option 3")
        
        let model4 = CustomSelectModel(withText: "Option 4", isEnabled: false)
        
        let model5 = CustomSelectModel(withText: "Option 5 to check whether the tableview is growing in its size if multiple lines of text is given", isEnabled: false)
        
        let model6 = CustomSelectModel(withText: "Option 6 to check whether the tableview is growing in its size if multiple lines of text is given", isEnabled: false)
        
        let model7 = CustomSelectModel(withText: "Option 7 to check whether the tableview is growing in its size if multiple lines of text is given", isEnabled: false)
        
        let model8 = CustomSelectModel(withText: "Option 8 to check whether the tableview is growing in its size if multiple lines of text is given", isEnabled: false)
        
        let model9 = CustomSelectModel(withText: "Option 9 to check whether the tableview is growing in its size if multiple lines of text is given", isEnabled: false)
        
        let model10 = CustomSelectModel(withText: "Option 10", isEnabled: false)
        
        let dropdownHelper = DropDownHelper.shared
        dropdownHelper.dropdownTitle = "Title goes here"
        dropdownHelper.datasource = [model1, model2, model3, model4, model5, model6, model7, model8, model9, model10]
        let tvc = CommonTableViewController.instantiate(dataSource: dropdownHelper, delegate: dropdownHelper)
        dropdownHelper.controller = tvc
        
        dropdownHelper.addPanel(with: dropdownHelper, controller: tvc, to: self)
    }
}

extension CustomDropDownViewController: CustomSelectHelperDelegate {
    
    func didTapCustomSelect(sender: CustomSelectHelper) {
        // Do your stuff here
    }
}
