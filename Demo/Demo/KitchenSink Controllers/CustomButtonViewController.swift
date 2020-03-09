//
//  CustomButtonViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 14/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomButtonViewController: UIViewController, CustomButtonDelegate, CustomAlertDelegate {
    func didTapRightButton(sender: Any, parent: Any) {
        print("right")
    }
    
    func didTapLeftButton(sender: Any, parent: Any) {
        print("right")
    }
    
    
    @IBOutlet weak var containedButton: CustomButton!
    @IBOutlet weak var outlineButton: CustomButton!
    @IBOutlet weak var ghostButton: CustomButton!
    @IBOutlet weak var disabledButton: CustomButton!
    @IBOutlet weak var containedImageButton: CustomButton!
    @IBOutlet weak var outlinedImageButton: CustomButton!
    @IBOutlet weak var ghostImageButton: CustomButton!
    @IBOutlet weak var disabledImageButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
    }
    
    func setupButtons() {
        containedButton.setButton(withTitle: "Contained Button", image: nil, type: .contained)
        containedButton.tag = 0
        containedButton.backgroundColor_ = UIColor.systemGreen
        outlineButton.setButton(withTitle: "Outlined Button", image: nil, type: .contained)
        outlineButton.tag = 1
        outlineButton.backgroundColor_ = UIColor.systemRed
        ghostButton.setButton(withTitle: "Ghost Button", image: nil, type: .ghost)
        ghostButton.tag = 2
        disabledButton.setButton(withTitle: "Disabled Button", image: nil, type: .disabled)
        
        containedImageButton.setButton(withTitle: nil, image: #imageLiteral(resourceName: "bag"), type: .contained)
        containedImageButton.tag = 3
        outlinedImageButton.setButton(withTitle: nil, image: #imageLiteral(resourceName: "bag"), type: .outlined)
        outlinedImageButton.tag = 4
        ghostImageButton.setButton(withTitle: nil, image: #imageLiteral(resourceName: "bag"), type: .ghost)
        disabledImageButton.setButton(withTitle: nil, image: #imageLiteral(resourceName: "bag"), type: .disabled)
        
        containedButton.delegate = self
        outlineButton.delegate = self
        ghostButton.delegate = self
        containedImageButton.delegate = self
    }

    func didTapButton(sender: Any) {
        
        let alert = CustomAlertViewController()
        alert.modalPresentationStyle = .overCurrentContext
        alert.rightButtonAction = { (sender) in
            print("right")
        }
        alert.leftButtonAction = { (sender) in
            print("left")
        }
        alert.delegate = self
        
        if let sender_ = sender as? CustomButton {
            
            switch sender_.tag {
            case 0:
                //alert.createAlert(attributedTitle: NSAttributedString(string: "Prominent Title Goes Here?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]), attributedDescription: NSAttributedString(string: "Your catchy description goes here.  Williamsburg truffaut af messenger bag fixie schlitz put a bird on it. Palo santo microdosing lyft.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.green]), attributedRightButtonTitle: NSAttributedString(string: "Click Me"), attributedLeftButtonTitle: nil, alertType: .info, shouldAutoDismiss: false, buttonType: .outlined)
                
                let walkthrough = CustomWalkthroughViewController()
                walkthrough.walkthroughBuilders = [walktroughBuilder(for: 1)]//, walktroughBuilder(for: 10), walktroughBuilder(for: 5)]
                walkthrough.rightButtonAction = { (sender, builder) in
                    walkthrough.addNewWalkthroughScreen(with: self.walktroughBuilder(for: 10))
                    //walkthrough.setupWalkthrough(for: walkthrough.currentWalkthroughIndex + 1)
                }
                walkthrough.leftButtonAction = { (sender, builder) in
                    //walkthrough.setupWalkthrough(for: walkthrough.currentWalkthroughIndex - 1)
                }
                self.present(walkthrough, animated: false, completion: nil)
                return
            case 1:
                
                let details = customBuilder()
                
                alert.createAlert(with: details)
                alert.closeButtonAction = { _ in
                    alert.dismiss(animated: false, completion: nil)
                }

            case 2:
                alert.createAlert(title: "Prominent Title Goes Here?", description: "Your catchy description goes here.  Williamsburg truffaut af messenger bag fixie schlitz put a bird on it. Palo santo microdosing lyft.", rightButtonTitle: "Click Me", leftButtonTitle: "Ok", alertType: .success)
            case 3:
                alert.createAlert(title: "Prominent Title Goes Here?", description: "Your catchy description goes here.  Williamsburg truffaut af messenger bag fixie schlitz put a bird on it. Palo santo microdosing lyft.", rightButtonTitle: "Click Me", leftButtonTitle: "Simple Action", alertType: .error)
            default:
                break
            }
            
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    func walktroughBuilder(for index: Int) -> WalkthroughBuilder {
        
        let walkthrough = WalkthroughBuilder {
            
            let title = NSAttributedString(string: "Prominent very long title goes here \(index) \n\n", attributes: [NSAttributedString.Key.font: UIFont(name: "EffraMedium-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            let subtext = NSAttributedString(string: "Short description about the new feature goes here \(index)", attributes: [NSAttributedString.Key.font: UIFont(name: "Effra-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            let combination = NSMutableAttributedString()
            combination.append(title)
            combination.append(subtext)
            
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "Walkthrough", bundle: bundle)
            let view_ = nib.instantiate(withOwner: self, options: nil).first as? UIView
            view_?.frame = CGRect(x: 10, y: 50, width: 100, height: 150)
            view_?.layer.cornerRadius = 24.0
            view_?.layer.borderWidth = 2.0
            view_?.layer.borderColor = UIColor(red: 0/255.0, green: 149/255.0, blue: 218/255.0, alpha: 1.0).cgColor
            $0.verticalAlignment = WalkthroughTextAlignment.imageAtTop
            $0.textAlignment = .left
            $0.title = combination
            $0.leftButtonType = Type.ghost
            $0.id = index
            
            if index == 1 {
                $0.view = view_
                $0.viewStartingPoint = CGPoint(x: 24 * index, y: 25 * index)
                $0.leftButtonActionType = .dismiss
                $0.rightButtonActionType = .next
                $0.onboardingCount = NSAttributedString(string: "1/3")
                $0.rightButtonTitle = NSAttributedString(string: "Next", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                $0.leftButtonTitle = NSAttributedString(string: "Skip", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            } else if index == 10 {
                $0.leftButtonActionType = .previous
                $0.rightButtonActionType = .next
                $0.onboardingCount = NSAttributedString(string: "2/3")
                $0.rightButtonTitle = NSAttributedString(string: "Next", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                $0.leftButtonTitle = NSAttributedString(string: "Go back", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            } else {
                $0.leftButtonActionType = .previous
                $0.rightButtonActionType = .dismiss
                $0.onboardingCount = NSAttributedString(string: "3/3")
                $0.rightButtonTitle = NSAttributedString(string: "Close", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                $0.leftButtonTitle = NSAttributedString(string: "Go back", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        return walkthrough
    }
    
    func customBuilder() -> AlertBuilder {
        
        let alert = AlertBuilder(build: {
            
            let stackview = UIStackView()
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 2
            titleLabel.attributedText = NSMutableAttributedString.init(string: "Yeay, You Receive Points!", attributes: [NSAttributedString.Key.font : UIFont.init(name: "EffraMedium-Regular", size: 20) as Any, NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)])
            
            let descriptionLabel = UILabel()
            descriptionLabel.numberOfLines = 0
            descriptionLabel.attributedText = NSMutableAttributedString.init(string: "You completed phone number verification and scored 400 Blibli Reward points!", attributes: [NSAttributedString.Key.font : UIFont.init(name: "Effra-Regular", size: 14) as Any, NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.38)])
            
            let bubble = CustomBubble()
            bubble.borderWidth = 2.0
            var rect = bubble.frame
            rect.size.width = 150.0
            bubble.frame = rect
            bubble.borderColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
            bubble.setMainButtonTitle("+ 400 Points!", titleColor: UIColor(red: 0, green: 178.0/255.0, blue: 90.0/255.0, alpha: 1.0))
            stackview.addArrangedSubview(titleLabel)
            stackview.addArrangedSubview(bubble)
            stackview.addArrangedSubview(descriptionLabel)
            
            $0.image = UIImage(named: "DLS-PNV_Success")
            $0.imagePosition = .center
            $0.stackView = stackview
            $0.rightButtonTitle = "OK"
            $0.leftButtonTitle = "Cancel"
            $0.buttonType = .contained
            $0.buttonPosition = .right
            $0.alertType = .custom
            $0.shouldShowCloseButton = true
        })
        
        return alert
    }
}
