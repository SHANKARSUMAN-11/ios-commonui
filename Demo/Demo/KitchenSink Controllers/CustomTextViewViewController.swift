//
//  CustomTextViewViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 25/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomTextViewViewController: UIViewController, CustomTextViewDelegate {
    
    @IBOutlet weak var customTextView: CustomTextView!
    let placeholder = "Email Address"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTextView()
    }
    
    func setTextView() {

        customTextView.delegate = self
        
        customTextView.helperText = NSAttributedString(string: "Content helper goes here")
        customTextView.placeholderText = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#ef3b42"), NSAttributedString.Key.font:
            UIFont(name: "Effra-Regular", size: 12.0) as Any])
//        customTextView.textFieldText = NSAttributedString(string: "ashokkumar@gmail.com")
        //        customTextView.textFieldBackgroundColor = UIColor.lightGray
        
        customTextView.maxAllowedCharacters = 3
        customTextView.errorStateColor = UIColor(hexString: "#ef3b42")
        customTextView.activeStateColor = UIColor(hexString: "#0095da")
        customTextView.successStateColor = UIColor(hexString: "#8bc63f")
        customTextView.defaultStateColor = UIColor.black.withAlphaComponent(0.38)
        
        customTextView.state = .plain
        
        //        customTextView.helperLabelNumberOfLines = 2
        
//        customTextView.setResultImage(withImageName: "error", imageColor: .red)
        //        customTextView.resultButtonWidth.constant = 25.0
//                customTextView.setCategoryImage(withImageName: "info")
        
    }

}

extension CustomTextViewViewController {
    
    func prepareTextViewForEditing() {
//        customTextView.setBorderColor(color: UIColor(hexString: "#0095da"))
//        customTextView.setPlaceholderLabelTextColor(color: UIColor(hexString: "#0095da"))
//        customTextView.setHelperLabel(text: NSAttributedString(string: "Content helper goes here"), andColor: UIColor(hexString: "#b7b7b7"))
//        customTextView.setResultImage(withImageName: nil)
    }
    
    func didTapRightButton(sender: Any, parent: Any) {
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView, parent: Any) -> Bool {
        prepareTextViewForEditing()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, parent: Any) -> Bool {
        
        if let text = textView.text {
            
            if text.isEmpty {
                customTextView.state = .plain
                
            } else if text.validate(type: .email) {
                customTextView.state = .success
                
            } else if text.count < 10 || text == placeholder {
                customTextView.state = .active
                
            } else {
                customTextView.state = .error
            }
        }
        
        return true
    }
}


