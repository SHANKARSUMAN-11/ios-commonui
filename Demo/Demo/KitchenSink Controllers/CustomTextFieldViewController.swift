//
//  CustomTextFieldViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 14/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomTextFieldViewController: UIViewController, CustomButtonDelegate {
    
    @IBOutlet weak var focusedTextField: CustomTextField!
//    @IBOutlet weak var customTextField: CustomTextField!
    @IBOutlet weak var customButton: CustomButton!
    
    let placeholder = "Email Address"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTextField()
    }
    
    func setTextField() {

        focusedTextField.delegate = self
        focusedTextField.enableSecuredText(withButton: true)
        
        focusedTextField.helperText = NSAttributedString(string: "Content helper goes here")
        focusedTextField.textFieldPlaceholderText = NSAttributedString(string: "Enter your email address")
        focusedTextField.headerPlaceholderText = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)])
        focusedTextField.textFieldText = NSAttributedString(string: "Populated Text", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#000000")])
//        focusedTextField.textFieldBackgroundColor = UIColor.lightGray
        
        focusedTextField.errorStateColor = UIColor(hexString: "#ef3b42")
        focusedTextField.activeStateColor = UIColor(hexString: "#0095da")
        focusedTextField.successStateColor = UIColor(hexString: "#8bc63f")
        focusedTextField.defaultStateColor = UIColor.black.withAlphaComponent(0.38)
        
        focusedTextField.state = .plain
        
//        focusedTextField.helperLabelNumberOfLines = 2
        
        focusedTextField.setResultImage(withImageName: "error", imageColor: .red)
//        focusedTextField.resultButtonWidth.constant = 25.0
//        focusedTextField.setCategoryImage(withImageName: "info")
        
    }
}

extension CustomTextFieldViewController: CustomTextFieldDelegate {
    
    func didTapRightButton(sender: Any, parent: Any) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField, parent: Any) -> Bool {
        return true
    }
    
    func textFieldDidChange(textField : UITextField, parent: Any) {
        
        if textField.tag == 0 {
            if let text = textField.text {
                
                if text.isEmpty {
                    focusedTextField.state = .plain
                    
                } else if text.validate(type: .email) {
                    focusedTextField.state = .success
                    
                } else if text.count < 10 {
                    focusedTextField.state = .active
                    
                } else {
                    focusedTextField.state = .error
                }
            }
        }
    }
}
