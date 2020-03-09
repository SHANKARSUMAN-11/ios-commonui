//
//  CustomLabelImageViewController.swift
//  Demo
//
//  Created by Yatin Dhingra on 14/08/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomLabelImageViewController: UIViewController {
    
    @IBOutlet weak var leftImageLabelRightImageLabel: CustomLabelImageView!
    @IBOutlet weak var ImageLabel: CustomLabelImageView!
    @IBOutlet weak var label: CustomLabelImageView!
    @IBOutlet weak var buttonLabel: CustomLabelImageView!
    @IBOutlet weak var twoButtons: CustomLabelImageView!
    @IBOutlet weak var viewWithCornerAndShadow: CustomLabelImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLeftImageLabelRightImageLabel()
        loadImageLabel()
        loadLabel()
        loadButtonLabel()
        loadTwoButtons()
        loadViewWithCornerAndShadow()
    }
    
    func loadLeftImageLabelRightImageLabel() {
        leftImageLabelRightImageLabel.setLeftImage(with: UIImage(named: "favorite"), state: .normal)
        leftImageLabelRightImageLabel.setRightImage(with: UIImage(named: "favorite"), state: .normal)
        
        leftImageLabelRightImageLabel.leftLabelText = NSAttributedString(string: "left Label Text dasdasfdasfasFASDFASDFASDFASDFASDFdasdajjasdnjkasdjkabsdjkabsjkdbasjkdbajksbdjkabsdjkabsdjkabjkdbasjkdbsajkbdajkbdsjkabsdjkasbd")
        leftImageLabelRightImageLabel.rightLabelText = NSAttributedString(string: "right Label Text")
        leftImageLabelRightImageLabel.leftButtonPosition = .top
        leftImageLabelRightImageLabel.rightButtonPosition = .center
        leftImageLabelRightImageLabel.rightTextAlignment = .right
        leftImageLabelRightImageLabel.shouldCompressLeftLabel = false
        leftImageLabelRightImageLabel.leftButtonWidth_ = 40
        leftImageLabelRightImageLabel.rightButtonWidth_ = 40
        
    }
    
    func loadImageLabel() {
        ImageLabel.setRightImage(with: UIImage(named: "favorite"), state: .normal)
        ImageLabel.rightButtonWidth_ = 40
        ImageLabel.leftLabelText = NSAttributedString(string: "Label Text")
    }

    func loadLabel() {
        label.isLeftLabelEnabled = true
        label.isRightLabelEnabled = true
        label.leftLabelText = NSAttributedString(string: "left Label Text")
        label.leftLabelAction = {
            (label) in
            print("did tap left label")
        }
        label.rightLabelAction = {
            (label) in
            print("did tap right label")
        }
        label.rightLabelText = NSAttributedString(string: "right Label Text")
    }
    
    func loadButtonLabel() {
        buttonLabel.setLeftButtonTitle(with: NSAttributedString(string: "left Button"), state: .normal)
        buttonLabel.leftButtonWidth_ = 100
        buttonLabel.leftLabelText = NSAttributedString(string: "left Label Text")
    }
    
    func loadTwoButtons() {
        let attachment = NSTextAttachment()
        attachment.image = #imageLiteral(resourceName: "favorite_selected")
        attachment.bounds = CGRect(x: 8, y: -3, width: 10, height: 13)
        let text = NSMutableAttributedString(attributedString: NSAttributedString(string: "left"))
        twoButtons.setLeftButtonTitle(with: NSAttributedString(string: "left Button", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#0095da")]), state: .normal)
        twoButtons.leftButtonWidth_ = 100
        twoButtons.leftButtonBackground = UIColor.lightGray
        twoButtons.leftButtonCornerRadius_ = 8
        twoButtons.isLeftButtonWidthActive = false
        twoButtons.leftButtonTop_ = 0
        twoButtons.setRightButtonTitle(with: text, state: .normal)
        twoButtons.setRightImage(with: #imageLiteral(resourceName: "favorite_selected"), state: .normal)
        twoButtons.rightButton.semanticContentAttribute = .forceRightToLeft
        twoButtons.rightButtonWidth_ = 100
        twoButtons.leftButtonAction = {(button) in
            print("left button tapped")
        }
        twoButtons.rightButtonAction = {(button) in
            print("right button tapped")
        }
    }
    
    func loadViewWithCornerAndShadow() {
        
        viewWithCornerAndShadow.setLeftImage(with: UIImage(named: "favorite"), state: .normal)
        viewWithCornerAndShadow.setRightImage(with: UIImage(named: "favorite"), state: .normal)
        viewWithCornerAndShadow.leftButtonWidth_ = 40
        viewWithCornerAndShadow.rightButtonWidth_ = 40
        viewWithCornerAndShadow.leftLabelText = NSAttributedString(string: "left")
        viewWithCornerAndShadow.rightLabelText = NSAttributedString(string: "right")
        viewWithCornerAndShadow.rightTextAlignment = .right
        viewWithCornerAndShadow.shouldCompressLeftLabel = true
        viewWithCornerAndShadow.helperBackgroundColor_ = .white
//        viewWithCornerAndShadow.radius_ = 8
//        viewWithCornerAndShadow.corners_ = [.topRight, .bottomLeft]
        viewWithCornerAndShadow.helperViewTopConstraint_ = 8
        viewWithCornerAndShadow.helperViewLeadingConstraint_ = 8
        viewWithCornerAndShadow.helperViewTrailingConstraint_ = 8
        viewWithCornerAndShadow.helperViewBottomConstraint_ = 8
        viewWithCornerAndShadow.cornerRadius_ = 8
        viewWithCornerAndShadow.leftButtonTop_ = 0
//        viewWithCornerAndShadow.helperBackgroundColor_ = UIColor.red
        viewWithCornerAndShadow.setShadow(radius: 4, shadowOffset: CGSize(width: 1, height: 1), shadowColor: UIColor.black, shadowOpacity: 0.4)
    }
}
