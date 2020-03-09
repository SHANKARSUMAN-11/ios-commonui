//
//  CustomWalkthroughViewController.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 19/02/20.
//  Copyright © 2020 Coviam. All rights reserved.
//

import UIKit

public enum ButtonActionType {
    case next
    case previous
    case dismiss
}

public class CustomWalkthroughViewController: UIViewController {

    public var rightButtonAction: ((UIButton, WalkthroughBuilder?) -> Void)?
    public var leftButtonAction: ((UIButton, WalkthroughBuilder?) -> Void)?
    
    public var walkthroughBuilders: [WalkthroughBuilder] = []
    public var currentWalkthroughIndex: Int = 0
    private var builder: WalkthroughBuilder? = nil
    private var walkthroughViews: [CustomWalkthroughView] = []
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public convenience init() {
        self.init(nibName: "CustomWalkthroughViewController", bundle: Bundle(for: CustomWalkthroughViewController.self))
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupWalkthrough(for: 0)
             
        setupBlurView()
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .allButUpsideDown
        }
        return .portrait
    }

    
    //MARK:- Button Action methods
    
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        self.leftButtonAction?(sender, self.builder)
    }
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        self.rightButtonAction?(sender, self.builder)
    }
    
    
    //MARK:- Private Methods
    
    public func addNewWalkthroughScreen(with newBuilder: WalkthroughBuilder) {
        
        walkthroughBuilders.append(newBuilder)
        
        if walkthroughBuilders.count > 0 {
            setupWalkthrough(for: walkthroughBuilders.count - 1)
        }
    }
    
    fileprivate func setupWalkthrough(for index: Int) {
        
        if walkthroughViews.count >= index + 1 {
            loadExistingWalkthroughView(for: index)
            
        } else {
            createNewWalkthroughView(for: index)
        }
    }
    
    fileprivate func loadExistingWalkthroughView(for index: Int) {
                
        let currentView = walkthroughViews[currentWalkthroughIndex]
        let newView = walkthroughViews[index]
        
        newView.isHidden = false
        newView.imageView?.alpha = 0.0
        
        newView.frame = currentView.frame
        var currentViewFrame = currentView.frame
        var newMainViewFrame = newView.masterView.frame
        
        if index < currentWalkthroughIndex {
            currentViewFrame.origin.x = UIScreen.main.bounds.width
            
            newMainViewFrame.origin.x = -1 * UIScreen.main.bounds.width
            newView.masterView.frame = newMainViewFrame
            
            newMainViewFrame.origin.x = 0
        } else {
            currentViewFrame.origin.x = -1 * UIScreen.main.bounds.width
            
            newMainViewFrame.origin.x = UIScreen.main.bounds.width
            newView.masterView.frame = newMainViewFrame
            
            newMainViewFrame.origin.x = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            newView.imageView?.alpha = 1.0
            currentView.imageView?.alpha = 0.0
            currentView.frame = currentViewFrame
            newView.masterView.frame = newMainViewFrame
        }) { (_) in
            self.builder = self.walkthroughBuilders.count >= index + 1 ? self.walkthroughBuilders[index] : nil
            self.currentWalkthroughIndex = index
        }
    }
    
    fileprivate func createNewWalkthroughView(for index: Int) {
        
        if index >= walkthroughBuilders.count {
            return
        }
        builder = walkthroughBuilders.count >= index + 1 ? walkthroughBuilders[index] : nil
        
        if index == 0 {
            currentWalkthroughIndex = index
        }
        
        let view_ = CustomWalkthroughView(frame: UIScreen.main.bounds)
        view_.setupView(with: builder)
        
        view_.rightButtonAction = { (sender) in
            self.handleButtonAction(for: self.builder?.rightButtonActionType)
            self.rightButtonAction?(sender, self.builder)
        }
        view_.leftButtonAction = { (sender) in
            self.handleButtonAction(for: self.builder?.leftButtonActionType)
            self.leftButtonAction?(sender, self.builder)
        }
        
        self.view.addSubview(view_)
        walkthroughViews.append(view_)
        
        if index != 0 {
            view_.isHidden = true
            loadExistingWalkthroughView(for: index)
        }
    }
    
    fileprivate func handleButtonAction(for actionType: ButtonActionType?) {
        
        if let actionType = actionType {
            
            switch actionType {
            case ButtonActionType.dismiss:
                self.dismiss(animated: true, completion: nil)
            case ButtonActionType.next:
                if walkthroughBuilders.count > currentWalkthroughIndex {
                    setupWalkthrough(for: currentWalkthroughIndex + 1)
                }
            case ButtonActionType.previous:
                if currentWalkthroughIndex > 0 {
                    setupWalkthrough(for: currentWalkthroughIndex - 1)
                }
            }
        }
    }
    
    fileprivate func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = builder?.backgroundColor
        blurView.clipsToBounds = true
        blurView.frame = UIScreen.main.bounds
        self.view.insertSubview(blurView, at: 0)
    }
}


//MARK:- Walkthrough Builder

///The builder / model for the Walkthrough. Please go through the definition of each attribute used in the build to understand how to use them.
public class WalkthroughBuilder {
    
    
    ///A unique identifier which can be used in future
    public var id: Int = 0
    
    
    ///The view that needs to be highlighted when the walkthrough is presented. No need to create this view from scratch. Since the walkthrough is actually for this view, this should already be there in the view hierarchy. Present the walkthrough only if this view is non-nil and pass in the same existing view to this variable
    public var view: UIView?
    
    
    ///The starting coordinate of the highlighting walkthrough view. The starting point should exactly match the starting point of the view in the main screen (for better alignment and look and feel). Not necessary to mention the frame of the view, but the starting point is mandatory to pass. If this is not passed, the view will not be shown.
    public var viewStartingPoint: CGPoint?
    
    
    ///The alignment of text and image. Set it to .textAtTop, if the walkthrough text should be shown above the image (example - if we decide to show a walkthrough for one of the Tabbar items, the walkthrough text cannot go below the image). Pass the walkthroughViewstartingPoint and set .textAtTop in the above use case. The default is set to .imageAtTop
    public var verticalAlignment: WalkthroughTextAlignment = .imageAtTop
    
    
    ///The walkthrough text. The title and description both to be passed with different attributes set to it. No separate field is provided for description text.
    public var title: NSAttributedString?
    
    
    ///Text Alignment in the screen. If the view to be highlighted is on the right most side, the text should be right aligned. Use this key in conjuction with the walkthroughViewstartingPoint to have image and text properly aligned. The default is set to .left
    public var textAlignment: Position = .left
    
    
    ///The  left action button type. The default is set to .outlined
    public var leftButtonType: Type?
    
    
    ///The right action button type. The default is set to .outlined
    public var rightButtonType: Type?
    
    
    ///The right action button title. Uses attributed string. The default is set to Effra-Regular-17.0 with default text color
    public var rightButtonTitle: NSAttributedString?
    
    
    ///The left action button title. Uses attributed string. The default is set to Effra-Regular-17.0 with default text color
    public var leftButtonTitle: NSAttributedString?
    
    
    ///The background color of the blur view. Default is set to use Blibli's blue color - rgba (1, 149, 218, 1) with alphaComponent - 0.64
    public var backgroundColor = UIColor(red: 0/255.0, green: 149/255.0, blue: 218/255.0, alpha: 1.0).withAlphaComponent(0.64)
    
    
    ///Corner Radius of the action buttons. Right now, there is no provision to set a different corner radius for the buttons. Both uses the same value. The default value is set to 16.0
    public var buttonCornerRadius: CGFloat?
    
    
    ///Border Width of the action buttons. Right now, there is no provision to set a different border width for the buttons. Both uses the same value. The default value is set to 2.0
    public var buttonBorderWidth: CGFloat?
    
    
    ///Border Color of the action buttons. Right now, there is no provision to set a different border colors for the buttons. Both uses the same value. The default color is set to white
    public var buttonBorderColor: UIColor?
    
        
    ///This type decides what should happen next when you tap on the left button. The default is set to .next. Setting .dismiss will not respect the changes done in the delegate method, but simply dismisses the controller. Setting it to .next or .previous will check for the walkthroughScreens array to find out any items are there to navigate. If it finds some elements, it will navigate or else it will wait for the delegate to inform the controller what to do next
    public var leftButtonActionType: ButtonActionType = .previous
    
    
    ///This type decides what should happen next when you tap on the right button. The default is set to .next. Setting .dismiss will not respect the changes done in the delegate method, but simply dismisses the controller. Setting it to .next or .previous will check for the walkthroughScreens array to find out any items are there to navigate. If it finds some elements, it will navigate or else it will wait for the delegate to inform the controller what to do next
    public var rightButtonActionType: ButtonActionType = .next
    
    
    ///The onboarding count to be shown in the walkthrough. If the value is not passed, the label will be hidden
    public var onboardingCount: NSAttributedString?
    
    
    public typealias closure = (WalkthroughBuilder) -> Void
    
    public init(build: closure) {
        build(self)
    }
}


///The enum which defines whether the image should be above or below the walkthrough text.
public enum WalkthroughTextAlignment {
    
    ///This case refers to image to be shown above the walkthrough text. This is the default case too in the Walkthrough. Refer to `verticalAlignment` parameter in the `WalkthroughBuilder` for reference
    case imageAtTop
    
    ///Set `verticalAlignment` parameter in the `WalkthroughBuilder` if the text need to be shown above the image to be highlighted
    case textAtTop
}
