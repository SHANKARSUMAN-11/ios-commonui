//
//  CustomLabelImageView.swift
//  CommonUIKit
//
//  Created by Yatin Dhingra on 13/08/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public class CustomLabelImageView: UIView {

    @IBOutlet public weak var leftButton: UIButton!
    @IBOutlet public weak var leftLabel: UILabel!
    @IBOutlet public weak var rightLabel: UILabel!
    @IBOutlet public weak var rightButton: UIButton!
    @IBOutlet weak var leftButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var helperView: UIView!
    @IBOutlet weak var helperViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var helperViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var helperViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var helperViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var view: UIView!
    @IBOutlet weak var leftButtonCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftLabelWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    /// completion for left button action
    public var leftButtonAction: ((UIButton) -> Void)?
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        self.leftButtonAction?(sender)
    }
    
    /// completion for right button action
    public var rightButtonAction: ((UIButton) -> Void)?
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        self.rightButtonAction?(sender)
    }
    
    /// completion for tap on left label
    public var leftLabelAction: ((UILabel) -> Void)?
    
    /// completion for tap on right label
    public var rightLabelAction: ((UILabel) -> Void)?
    
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomLabelImageView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        leftLabel.text = ""
        leftLabel.numberOfLines = 0
        rightLabel.text = ""
        rightLabel.numberOfLines = 0
        setLeftButtonTitle(with: nil, state: .normal)
        setRightButtonTitle(with: nil, state: .normal)
    
        helperViewTopConstraint.constant = 0
        helperViewBottomConstraint.constant = 0
        helperViewLeadingConstraint.constant = 0
        helperViewTrailingConstraint.constant = 0
        setRightImage()
        setLeftImage()
        leftButton.isUserInteractionEnabled = false
        rightButton.isUserInteractionEnabled = false
    }
    
    @objc func didTapLeftLabel(_ sender: UITapGestureRecognizer) {
        self.leftLabelAction?(leftLabel)
    }
    
    @objc func didTapRightLabel(_ sender: UITapGestureRecognizer) {
        self.rightLabelAction?(rightLabel)
    }
    
    public var isLeftLabelEnabled: Bool = false {
        didSet {
            let leftTap = UITapGestureRecognizer(target: self, action: #selector(self.didTapLeftLabel(_:)))
            leftLabel.isUserInteractionEnabled = isLeftLabelEnabled
            leftLabel.addGestureRecognizer(leftTap)
        }
    }
    
    public var isRightLabelEnabled: Bool = false {
        didSet {
            let rightTap = UITapGestureRecognizer(target: self, action: #selector(self.didTapRightLabel(_:)))
            rightLabel.isUserInteractionEnabled = isRightLabelEnabled
            rightLabel.addGestureRecognizer(rightTap)
        }
    }
    
    /// set the left button Position. Input Type: Vertical Position
    public var leftButtonPosition: verticalPosition = .center {
        didSet {
            self.leftButtonCenterConstraint.priority = UILayoutPriority.init(rawValue: 1)
            switch leftButtonPosition {
            case .top:
                let buttonY = self.leftButton.topAnchor.constraint(equalTo: leftLabel.topAnchor)
                NSLayoutConstraint.activate([buttonY])
            case .center:
                let buttonY = self.leftButton.centerYAnchor.constraint(equalTo: leftLabel.centerYAnchor)
                NSLayoutConstraint.activate([buttonY])
            case .bottom:
                let buttonY = self.leftButton.bottomAnchor.constraint(equalTo: leftLabel.bottomAnchor)
                NSLayoutConstraint.activate([buttonY])
            }
        }
    }
    
    /// set the right button Position. Input Type: Vertical Position
    public var rightButtonPosition: verticalPosition = .center {
        didSet {
            self.rightButtonCenterConstraint.priority = UILayoutPriority.init(rawValue: 1)
            switch rightButtonPosition {
            case .top:
                let buttonY = self.rightButton.topAnchor.constraint(equalTo: rightLabel.topAnchor)
                NSLayoutConstraint.activate([buttonY])
            case .center:
                let buttonY = self.rightButton.centerYAnchor.constraint(equalTo: rightLabel.centerYAnchor)
                NSLayoutConstraint.activate([buttonY])
            case .bottom:
                let buttonY = self.rightButton.bottomAnchor.constraint(equalTo: rightLabel.bottomAnchor)
                NSLayoutConstraint.activate([buttonY])
            }
        }
    }
    
    /// set the border color for right button. Input Type: UIColor
    public var rightButtonBorderColor: UIColor = .clear {
        didSet {
            self.rightButton.layer.borderColor = rightButtonBorderColor.cgColor
        }
    }
    
    /// set the border width for right button. Input Type: CGFloat?
    public var rightButtonBorderWidth: CGFloat = 0 {
        didSet {
            self.rightButton.layer.borderWidth = rightButtonBorderWidth
        }
    }
    
    /// set the border color for left button. Input Type: UIColor
    public var leftButtonBorderColor: UIColor = .clear {
        didSet {
            self.leftButton.layer.borderColor = leftButtonBorderColor.cgColor
        }
    }
    
    /// set the border width for the left button. Input Type: CGFloat?
    public var leftButtonBorderWidth: CGFloat = 0 {
        didSet {
            self.leftButton.layer.borderWidth = leftButtonBorderWidth
        }
    }
    
    /// set the background color for left label. Input Type: UIColor
    public var leftLabelColor: UIColor = .clear {
        didSet {
            self.leftLabel.backgroundColor = leftLabelColor
        }
    }
    
    /// set the background color for right label. Input Type: UIColor
    public var rightlabelColor: UIColor = .clear {
        didSet {
            self.rightLabel.backgroundColor = rightlabelColor
        }
    }
    
    /// set the left image tint. Input Type: UIColor
    public var leftImageTint: UIColor? = .clear {
        didSet {
            self.leftButton.imageView?.tintColor = leftImageTint
        }
    }
    
    /// set the right image tint. Input Type: UIColor
    public var rightImageTint: UIColor? = .clear {
        didSet {
            self.rightButton.imageView?.tintColor = rightImageTint
        }
    }
    
    /// set the corner radius for the helper view. Input Type: CGFloat
    public var cornerRadius_: CGFloat = 0 {
        didSet {
            self.helperView.layer.cornerRadius = cornerRadius_
        }
    }
    
    /// set the sides on which corner radius is required. Should be used with radius_. Input Type: UIRectCorner?
    public var corners_: UIRectCorner?
    
    /// set the corner radius for the sides specified in corners_. Input Type: CGFloat?
    public var radius_: CGFloat?
    
    /// set the border color for the helper view. Input Type: UIColor
    public var borderColor_: UIColor = UIColor.clear {
        didSet {
            self.helperView.layer.borderColor = borderColor_.cgColor
        }
    }
    
    /// set the border width for the helper view. Input Type: CGFloat
    public var borderWidth_: CGFloat = 0.0 {
        didSet {
            self.helperView.layer.borderWidth = borderWidth_
        }
    }
    
    /// set the number of lines for left label
    public var leftLabelNumberOfLines_: Int = 0 {
        didSet {
            self.leftLabel.numberOfLines = leftLabelNumberOfLines_
        }
    }
    
    /// set the number of lines for right label
    public var rightLabelNumberOfLines_: Int = 0 {
        didSet {
            self.rightLabel.numberOfLines = rightLabelNumberOfLines_
        }
    }
    
    /// set the corner radius for the left button. Input Type: CGFloat
    public var leftButtonCornerRadius_: CGFloat = 0 {
        didSet {
            self.leftButton.layer.cornerRadius = leftButtonCornerRadius_
        }
    }
    
    /// set the corner radius for the right button. Input Type: CGFloat
    public var rightButtonCornerRadius_: CGFloat = 0 {
        didSet {
            self.rightButton.layer.cornerRadius = rightButtonCornerRadius_
        }
    }
    
    /// set the text for left label. Input Type: NSAttributedString?
    public var leftLabelText: NSAttributedString? = nil {
        didSet {
            self.leftLabel.attributedText = leftLabelText
        }
    }
    
    /// set the text for right label. Input Type: NSAttributedString?
    public var rightLabelText: NSAttributedString? = nil {
        didSet {
            self.rightLabel.attributedText = rightLabelText
        }
    }
    
    /// set the alignment for left label text. Deafult value = .left. Input Type: NSTextAlignment
    public var leftTextAlignment: NSTextAlignment = .left {
        didSet {
            self.leftLabel.textAlignment = leftTextAlignment
        }
    }
    
    /// set the alignment for right label text. Default value = .right. Input Type: NSTextAlignment
    public var rightTextAlignment: NSTextAlignment = .right {
        didSet {
            self.rightLabel.textAlignment = rightTextAlignment
        }
    }
    
    /// used to set the interaction for left button. set it to false is to be used only as an image. Default Value = false. Input Type: Bool
    public var isLeftButtonEnabled: Bool = false {
        didSet {
            self.leftButton.isUserInteractionEnabled = isLeftButtonEnabled
        }
    }
    
    /// used to set the interaction for right button. set it to false is to be used only as an image. Default Value = false. Input Type: Bool
    public var isRightButtonEnabled: Bool = false {
        didSet {
            self.rightButton.isUserInteractionEnabled = isRightButtonEnabled
        }
    }
    
    /// set the title for left button. user needs to set the width of the button to make it visible. user interaction for button is enable when this method is triggered
    ///
    /// - Parameters:
    ///   - title: set the title. Input Type: NSAttributedString?
    ///   - state: set the state for which title is to be set. Input Type: UIControl.State
    public func setLeftButtonTitle(with title: NSAttributedString?, state: UIControl.State) {
        if title != nil {
            self.leftButton.setAttributedTitle(title, for: state)
            isLeftButtonEnabled = true
            leftButtonLeadingConstraint_ = 16
        } else {
            self.leftButton.setTitle("", for: state)
            isLeftButtonEnabled = false
            leftButtonLeadingConstraint_ = 0
        }
    }
    
    /// set the image for left side. user needs to set the image width to make it visible. set the user interaction as per the need.
    ///
    /// - Parameters:
    ///   - image: set the image. Input Type: UIImage?
    ///   - state: set the state for which image needs to be set. Input Type: UIControl.State
    public func setLeftImage(with image: UIImage? = nil, state: UIControl.State = .normal) {
        if image != nil {
            self.leftButton.setImage(image, for: state)
            leftButtonLeadingConstraint_ = 16
        } else {
            leftButtonLeadingConstraint_ = 0
            leftButtonWidth_ = 0
        }
    }
    
    /// set the background color for left button. Input Type: UIColor?
    public var leftButtonBackground: UIColor? = UIColor.clear {
        didSet {
            self.leftButton.backgroundColor = leftButtonBackground
        }
    }
    
    /// set the title for right button. user needs to set the width of the button to make it visible. user interaction for button is enable when this method is triggered
    ///
    /// - Parameters:
    ///   - title: set the title. Input Type: NSAttributedString?
    ///   - state: set the state for the title. Input Type: UIControl.State
    public func setRightButtonTitle(with title: NSAttributedString?, state: UIControl.State) {
        if title != nil {
            self.rightButton.setAttributedTitle(title, for: state)
            isRightButtonEnabled = true
            rightButtonTrailingConstraint_ = 16
        } else {
            self.rightButton.setTitle("", for: state)
            isRightButtonEnabled = false
            rightButtonTrailingConstraint_ = 0
        }
    }
    
    /// set the image for left side. user needs to set the image width to make it visible. set the user interaction as per the need.
    ///
    /// - Parameters:
    ///   - image: set the image. Input Type: UIImage?
    ///   - state: set the state for which image needs to be set. Input Type: UIControl.State
    public func setRightImage(with image: UIImage? = nil, state: UIControl.State = .normal) {
        if image != nil {
            self.rightButton.setImage(image, for: state)
            rightButtonTrailingConstraint_ = 16
        } else {
            rightButtonTrailingConstraint_ = 0
            rightButtonWidth_ = 0
        }
    }
    
    /// set the background color for right button. Input Type: UIColor?
    public var rightButtonBackground: UIColor? = UIColor.clear {
        didSet {
            self.rightButton.backgroundColor = rightButtonBackground
        }
    }
    
    /// set the left image edge insets. Input Type: UIEdgeInsets
    public var leftImageInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            self.leftButton.imageEdgeInsets = leftImageInset
        }
    }
    
    /// set the right image edge insets. Input Type UIEdgeInsets
    public var rightImageInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            self.rightButton.imageEdgeInsets = rightImageInset
        }
    }
    
    /// to set content compression priority. if true: it will compress content of left label. if false: it will compress the contents of right label. Default Value: true. Input Type: Bool
    public var shouldCompressLeftLabel: Bool = true {
        didSet {
            if shouldCompressLeftLabel {
                self.leftLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                self.rightLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            } else {
                self.leftLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
                self.rightLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            }
        }
    }
    
    /// set the width of left buton. Input Type: CGFloat
    public var leftButtonWidth_: CGFloat = 0 {
        didSet {
            self.leftButtonWidthConstraint.constant = leftButtonWidth_
        }
    }
    
    /// set the height of left button. Input Type: CGFloat
    public var leftButtonHeight_: CGFloat = 0 {
        didSet {
            self.leftButtonHeightConstraint.constant = leftButtonHeight_
        }
    }
    
    /// set the width of right button. Input Type: CGFLoat
    public var rightButtonWidth_: CGFloat = 0 {
        didSet {
            self.rightButtonWidthConstraint.constant = rightButtonWidth_
        }
    }
    
    /// set the height of right button. Input Type: CGFloat
    public var rightButtonHeight_: CGFloat = 0 {
        didSet {
            self.rightButtonHeightConstraint.constant = rightButtonHeight_
        }
    }
    
    /// set the leading constraint constant for left button. Set this value after setting the left button title or image. Input Type: CGFloat
    public var leftButtonLeadingConstraint_: CGFloat = 0 {
        didSet {
            self.leftButtonLeadingConstraint.constant = leftButtonLeadingConstraint_
        }
    }
    
    /// set the leading constraint constant for left label. Input Type: CGFloat
    public var leftLabelLeadingConstraint_: CGFloat = 0 {
        didSet {
            self.leftLabelLeadingConstraint.constant = leftLabelLeadingConstraint_
        }
    }
    
    /// set the leading constraint constant for right label. Input Type: CGFloat
    public var rightLabelLeadingConstraint_: CGFloat = 0 {
        didSet {
            self.rightLabelLeadingConstraint.constant = rightLabelLeadingConstraint_
        }
    }
    
    /// set the leading constraint constant for right button. Input Type: CGFloat
    public var rightButtonLeadingConstraint_: CGFloat = 0 {
        didSet {
            self.rightButtonLeadingConstraint.constant = rightButtonLeadingConstraint_
        }
    }
    
    /// set the trailing constraint constant for right button. Set this value after setting right button title or image. Input Type: CGFloat
    public var rightButtonTrailingConstraint_: CGFloat = 0 {
        didSet {
            self.rightButtonTrailingConstraint.constant = rightButtonTrailingConstraint_
        }
    }
    
    /// set the top constraint constant for helper view. Default value = 0.0. Input Type: CGFLoat
    public var helperViewTopConstraint_: CGFloat = 0 {
        didSet {
            self.helperViewTopConstraint.constant = helperViewTopConstraint_
        }
    }
    
    /// set the bottom constraint constant for helper view. Default value = 0.0. Input Type: CGFLoat
    public var helperViewBottomConstraint_: CGFloat = 0 {
        didSet {
            self.helperViewBottomConstraint.constant = helperViewBottomConstraint_
        }
    }
    
    /// set the leading constraint constant for helper view. Default value = 0.0. Input Type: CGFLoat
    public var helperViewLeadingConstraint_: CGFloat = 0 {
        didSet {
            self.helperViewLeadingConstraint.constant = helperViewLeadingConstraint_
        }
    }
    
    /// set the trailing constraint constant for helper view. Default value = 0.0. Input Type: CGFLoat
    public var helperViewTrailingConstraint_: CGFloat = 0 {
        didSet {
            self.helperViewTrailingConstraint.constant = helperViewTrailingConstraint_
        }
    }
    
    public var leftButtonTop_: CGFloat = 0 {
        didSet {
            self.leftButtonTopConstraint.constant = leftButtonTop_
        }
    }
    
    public var leftButtonBottom_: CGFloat = 0 {
        didSet {
            self.leftButtonBottomConstraint.constant = leftButtonBottom_
        }
    }
    
    public var rightButtonTop_: CGFloat = 0 {
        didSet {
            self.rightButtonTopConstraint.constant = rightButtonTop_
        }
    }
    
    public var rightButtonBottom_: CGFloat = 0 {
        didSet {
            self.rightButtonBottomConstraint.constant = rightButtonBottom_
        }
    }
    
    public var leftLabelWidth_: CGFloat = 0 {
        didSet {
            self.leftLabelWidthConstraint.constant = leftLabelWidth_
        }
    }
    
    public var rightLabelWidth_: CGFloat = 0 {
        didSet {
            self.rightLabelWidthConstraint.constant = rightLabelWidth_
        }
    }
    
    public var isLeftButtonWidthActive: Bool = true {
        didSet {
            self.leftButtonWidthConstraint.isActive = isLeftButtonWidthActive
        }
    }
    
    public var isLeftButtonHeightActive: Bool = true {
        didSet {
            self.leftButtonHeightConstraint.isActive = isLeftButtonHeightActive
        }
    }
    
    public var isRightButtonWidthActive: Bool = true {
        didSet {
            self.rightButtonWidthConstraint.isActive = isRightButtonWidthActive
        }
    }
    
    public var isRightButtonHeightActive: Bool = true {
        didSet {
            self.rightButtonHeightConstraint.isActive = isRightButtonHeightActive
        }
    }
    
    /// set background color for the entire view. Input Type: UIColor?
    public var backgroundColor_: UIColor? = UIColor.clear {
        didSet {
            self.view.backgroundColor = backgroundColor_
        }
    }
    
    /// set background color for helper view. Input Type: UIColor?
    public var helperBackgroundColor_: UIColor? = UIColor.clear {
        didSet {
            self.helperView.backgroundColor = helperBackgroundColor_
        }
    }
    
    /// to set the shadow for the view
    ///
    /// - Parameters:
    ///   - radius: shadow radius. Input Type: CGFloat
    ///   - shadowOffset: shadow Offset. Input Type: CGSize
    ///   - shadowColor: shadow color. Input Type: UIColor
    ///   - shadowOpacity: shadow Opacity. Input Type: UIColor
    public func setShadow(radius: CGFloat, shadowOffset: CGSize, shadowColor: UIColor, shadowOpacity: Float) {
        self.helperView.addShadow(radius: radius, shadowOffset: shadowOffset, shadowColor: shadowColor, shadowOpacity: shadowOpacity)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            if let corner = self.corners_, let radius = self.radius_ {
                self.helperView.roundedCorners(corners: corner, radius: radius)
            } else {
                self.helperView.layer.mask = nil
            }
        }
        
    }
}

