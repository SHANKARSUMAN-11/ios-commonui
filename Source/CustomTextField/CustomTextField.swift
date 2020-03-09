//
//  CustomTextField.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 12/03/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

/**
 The enum is used in conjuction with the boolean -shouldUpdateFieldsForStateChange. Check the description of the boolean on how it works
 */
public enum TextAreaState {
    
    /// The default state of the TextField / TextView. If the boolean is set, TextField / TextView placeholder color, BorderColor will be taken from the properties
    case plain
    
    /// Active state indicates the TextField / TextView has become the first responder (being edited)
    case active
    
    /// Error - Some of the mandatory validation has failed
    case error
    
    /// All validations are successful for the current TextField / TextView
    case success
    
    /// Apart from the four states defined, if any other state needs to be handled, use the custom enum to hanlde it
    case custom
}

public protocol CustomTextFieldDelegate: class {
    func didTapRightButton(sender: Any, parent: Any)
    func textFieldDidChange(textField: UITextField, parent: Any)
    func textFieldShouldBeginEditing(_ textField: UITextField, parent: Any) -> Bool
    func textFieldDidBeginEditing(_ textField: UITextField, parent: Any)
    func textFieldDidEndEditing(_ textField: UITextField, parent: Any)
    func textFieldShouldClear(_ textField: UITextField, parent: Any) -> Bool
    func textFieldShouldReturn(_ textField: UITextField, parent: Any) -> Bool
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason, parent: Any)
    func textFieldShouldEndEditing(_ textField: UITextField, parent: Any) -> Bool
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, parent: Any) -> Bool
}

public extension CustomTextFieldDelegate {
    func textFieldDidChange(textField: UITextField, parent: Any) {}
    func didTapRightButton(sender: Any, parent: Any) {}
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { return true }
    func textFieldDidBeginEditing(_ textField: UITextField, parent: Any) {}
    func textFieldDidEndEditing(_ textField: UITextField, parent: Any) {}
    func textFieldShouldClear(_ textField: UITextField, parent: Any) -> Bool { return true }
    func textFieldShouldReturn(_ textField: UITextField, parent: Any) -> Bool { return true }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason, parent: Any) {}
    func textFieldShouldEndEditing(_ textField: UITextField, parent: Any) -> Bool { return true }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, parent: Any) -> Bool { return true }
}

public class CustomTextField: UIView, UITextFieldDelegate {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet public weak var placeholderLabel: UILabel!
    @IBOutlet public weak var textField: UITextField!
    @IBOutlet public weak var helperLabel: UILabel!
    @IBOutlet public weak var helperLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet public weak var categoryImageViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var categoryImageLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet public weak var detailImageView: UIImageView!
    @IBOutlet public weak var detailImageWidth: NSLayoutConstraint!
    @IBOutlet public weak var detailImageHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet public weak var resultButtonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var toggleButton: UIButton!
    
    @IBOutlet weak var rightContainerButton: UIStackView!
    @IBOutlet public weak var rightContainerButtonTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet public weak var textFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var separatorView: UIView!
    @IBOutlet weak var separatorViewHeight: NSLayoutConstraint!
    
    public weak var delegate: CustomTextFieldDelegate? = nil
    var component: Component.TextField? = nil
    
    
    ///Border Color of the complete Custom TextField View. The Custom TextField includes the TextField and the Placeholder label, excludes the helper label. Default is set to clear color
    public var borderColor_: UIColor? = .clear {
        didSet {
            self.textFieldView.layer.borderColor = self.borderColor_?.cgColor
        }
    }
    
    ///Border Width of the complete Custom TextField View. The Custom TextField includes the TextField and the Placeholder label, excludes the helper label. Default is set to 0
    public var borderWidth_: CGFloat = 0.0 {
        didSet {
            self.textFieldView.layer.borderWidth = self.borderWidth_
        }
    }
    
    ///Corner Radius of the complete Custom TextField View. The Custom TextField includes the TextField and the Placeholder label, excludes the helper label. Default is set to 0
    public var cornerRadius_: CGFloat = 0.0 {
        didSet {
            self.textFieldView.layer.cornerRadius = self.cornerRadius_
        }
    }
    
    ///Background Color of the complete Custom TextField View. The Custom TextField includes the TextField and the Placeholder label, excludes the helper label. Default is set to clear color
    public var backgroundColor_: UIColor? = .clear {
        didSet {
            self.view.backgroundColor = self.backgroundColor_
        }
    }
    
    ///The state of the TextField / TextView. Based on the state value and if the -shouldUpdateFieldsForStateChange boolean is set, Placeholder text color, helper label text color and the textField / textView border color will be changed
    public var state: TextAreaState = .plain {
        didSet {
            self.configureTextField(for: state)
        }
    }
    
    /*
    ///The textField text color. Default is set to black
    @IBInspectable
    public var textColor: UIColor = .black {
        didSet {
            self.textField.textColor = self.textColor
        }
    }
    
    ///The placeholder label text color. Default is set to black
    @IBInspectable
    public var placeHolderTextColor: UIColor = .black {
        didSet {
            self.placeholderLabel.textColor = self.placeHolderTextColor
        }
    }
    
    ///The helper label text color. Default is set to black
    @IBInspectable
    public var helperLabelTextColor: UIColor = .black {
        didSet {
            self.helperLabel.textColor = self.helperLabelTextColor
        }
    }
    */
    
    ///Background Color of the TextField. To set the background color for the complete view, use -backgroundColor_ property
    public var textFieldBackgroundColor: UIColor? = .clear {
        didSet {
            self.textFieldView.backgroundColor = self.textFieldBackgroundColor
        }
    }
    
    ///The separator view is created to support a different UI. When the client app does not want a border around the text field, but want a view below the text field, this separator can be used. Pass a single color to this property to have a solid background color, or pass array of colors to have a gradient effect
    public var separatorColor: [UIColor]? = nil {
        didSet {
            self.setGradient()
        }
    }
    
    ///Separator height incase if there is no border needed around the textField. Default is set to 0
    public var separatorHeight: CGFloat = 0.0 {
        didSet {
            if separatorHeight > CGFloat(0.0) {
                self.separatorViewHeight.constant = separatorHeight
                self.separatorView.isHidden = false
            } else {
                self.separatorView.isHidden = true
            }
        }
    }
    
    ///Sets the textField text. Use this to set the text, text color, font etc. This attribure should be set after setting up the -placeholderText property
    public var textFieldText: NSAttributedString? = nil {
        didSet {
            self.setText()
        }
    }
    
    ///Sets the placeholder text. Use this to set the text, text color, font etc
    public var placeholderText: NSAttributedString? = nil {
        didSet {
            self.setText()
        }
    }
    
    ///Sets the header for textfield and Placeholder for textField unless textFieldPlaceholderText is not set. Use this to set the text, text color, font etc
    public var headerPlaceholderText: NSAttributedString? = nil {
        didSet {
            self.placeholderText = headerPlaceholderText
        }
    }
    
    ///Sets the textfield's Placeholder and to be set after setting headerPlaceholderText
    public var textFieldPlaceholderText: NSAttributedString? = nil {
        didSet {
            self.setText()
           // self.textField.attributedPlaceholder = textFieldPlaceholderText
        }
    }
    
    ///Sets the textField text. Use this to set the text, text color, font etc
    public var helperText: NSAttributedString? = nil {
        didSet {
            self.helperLabel.attributedText = helperText
        }
    }
    
    ///Sets the textField text alignment. Default is set to left aligned
    public var textFieldTextAlignment: NSTextAlignment = .left {
        didSet {
            self.textField.textAlignment = textFieldTextAlignment
        }
    }
    
    ///Sets the Placeholder label text alignment. Default is set to left aligned
    public var placeholderTextAlignment: NSTextAlignment = .left {
        didSet {
            self.placeholderLabel.textAlignment = placeholderTextAlignment
        }
    }
    
    ///Sets the helper label text alignment. Default is set to left aligned
    public var helperTextAlignment: NSTextAlignment = .left {
        didSet {
            self.helperLabel.textAlignment = helperTextAlignment
        }
    }
    
    ///Max number of characters are allowed for the TextView
    public var maxAllowedCharacters: Int = 1000000
    
    ///Active State indicates that the textField has became the firstResponder. When the textField is being edited, this color will be applied to the fields. If -shouldUpdateFieldsForStateChange property is set to true, the color will be applied to placeholder label, border color, helper label and the result button image 
    public var activeStateColor: UIColor = .clear
    
    
    ///Default State indicates that the textField is visible but not being edited now. If -shouldUpdateFieldsForStateChange property is set to true, the color will be applied to placeholder label, border color, helper label and the result button image
    public var defaultStateColor: UIColor = .clear
    
    
    ///Success State indicates that the textField has resigned from the firstResponder. When the textField is done editing and all the validations are successful, this color will be applied to the fields. If -shouldUpdateFieldsForStateChange property is set to true, the color will be applied to placeholder label, border color, helper label and the result button image
    public var successStateColor: UIColor = .clear
    
    
    ///Error State indicates that the textField has resigned from the firstResponder. When the textField is done editing and some of the validations are unsuccessful, this color will be applied to the fields. If -shouldUpdateFieldsForStateChange property is set to true, the color will be applied to placeholder label, border color, helper label and the result button image
    public var errorStateColor: UIColor = .clear
    
    
    ///The boolean variable that indicates whether the state change should change the color of the fields or not. If set to true, the state change color will be applied to placeholder label, border color, helper label and the result button image. Default is set to true
    public var shouldUpdateFieldsForStateChange: Bool = true
    
    
    ///The helper label number of lines to be displayed. Default number of line(s) is 1
    public var helperLabelNumberOfLines: Int = 1 {
        didSet {
            self.helperLabel.numberOfLines = helperLabelNumberOfLines
        }
    }
    
    
    //MARK:- Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomTextField", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        
        component = Configuration.shared.getComponent()?.TextField
        self.backgroundColor_ = component?.getBackgroundColor()
        self.borderColor_ = component?.getBorderColor()
        self.borderWidth_ = component?.borderWidth ?? kDefaultBorderWidth
        self.cornerRadius_ = component?.cornerRadius ?? kDefaultCornerRadius
        self.separatorViewHeight.constant = component?.separatorHeight ?? kDefaultSeparatorHeight
        self.separatorColor = nil
        self.state = .plain
        self.helperLabelNumberOfLines = 2
        self.textFieldText = NSAttributedString(string: "")
        
        self.setCategoryImage(withImageName: nil)
        self.setResultImage(withImageName: nil)
        
        self.textField.delegate = self
        
        self.textField.addTarget(self, action: #selector(CustomTextField.textFieldDidChange(textField:)), for: .editingChanged)

//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextFieldView))
//        textFieldView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapTextFieldView(_ sender: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }
    
    /**
     This function will enable secured text option in the textfield
     If you choose with button, revealing / unrevealing button will be available to the text field
     */
    public func enableSecuredText(withButton: Bool){
        self.textField.isSecureTextEntry = true
        if (withButton){
            self.toggleButton.isHidden = false
            self.toggleButton.setImage(UIImage().getImage(named: "eye_hidden"), for: .normal)
            self.toggleButton.addTarget(self, action: #selector(CustomTextField.didTapToggleSecuredText), for: .touchUpInside)
            self.setRightContainerButtonConstraint()
        }
    }
    
    @objc func didTapToggleSecuredText(){
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
        let iconName = self.textField.isSecureTextEntry == true ? "eye_hidden" : "eye_revealed"
        toggleButton.setImage(UIImage().getImage(named: iconName), for: .normal)
    }
    
    
    /**
     Automatically handles the TextField text and the placeholder text.
     
     1. If the textFieldText is nil, then the textField's placeholder is set and the placeholder text is set to nil
     2. Else, the placeholder and the textField is set to its respective values
     */
    func setText() {
        
        if self.textFieldText == nil || self.textFieldText?.string.isEmpty ?? true {
            
            self.textField.attributedText = nil
            
            if let existingText = textFieldText?.mutableCopy() as? NSMutableAttributedString, let placeholder = placeholderText?.string {
                existingText.mutableString.setString(placeholder)
                self.textField.attributedPlaceholder = textFieldPlaceholderText ?? existingText
                
            } else {
                self.textField.attributedPlaceholder = textFieldPlaceholderText ?? placeholderText
            }
            
            self.placeholderLabel.attributedText = nil
            
        } else {
            self.textField.attributedText = textFieldText
            self.placeholderLabel.attributedText = placeholderText
            
            if let existingText = textFieldText?.mutableCopy() as? NSMutableAttributedString, let placeholder = placeholderText?.string {
                existingText.mutableString.setString(placeholder)
                self.textField.attributedPlaceholder = textFieldPlaceholderText ?? existingText
                
            }
        }
    }
    
    /**
     Configures the TextField with different state values
     - Parameter state: The state of the TextField
     - seeAlso: TextAreaState
     */
    func configureTextField(for state: TextAreaState) {
        
        if self.shouldUpdateFieldsForStateChange {
            switch state {
            case .active:
                self.borderColor_ = activeStateColor
                self.placeholderLabel.textColor = activeStateColor
                self.helperLabel.textColor = activeStateColor
            case .error:
                self.borderColor_ = errorStateColor
                self.placeholderLabel.textColor = errorStateColor
                self.helperLabel.textColor = errorStateColor
            case .success:
                self.borderColor_ = successStateColor
                self.placeholderLabel.textColor = successStateColor
                self.helperLabel.textColor = successStateColor
            default:
                self.borderColor_ = defaultStateColor
                self.placeholderLabel.textColor = defaultStateColor
                self.helperLabel.textColor = defaultStateColor
            }
        }
    }
    
    /**
    Used to set the gradient background for the TextField separator.
    
     1. The method will try to remove the gradient layer (if one is available).
     2. In the separatorColor property, if there is only one color is available, it will set it as a backgroundColor
     3. If there are more than one color, it will create the gradient layer and will assign to the separatorView
     4. if the color is nil or empty array, or no elements found, the backgroundColor will be set to clear color.
    */
    func setGradient() {
        
        if let gradientLayer = separatorView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        
        if let colors = separatorColor {
            
            if colors.count == 1 {
                separatorView.backgroundColor = colors.first
                
            } else if colors.count == 0 {
                separatorView.backgroundColor = .clear
                
            } else {
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                
                let bounds = separatorView.bounds
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: separatorViewHeight.constant)
                
                gradientLayer.colors = colors.map{ $0.cgColor }
                
                separatorView.layer.insertSublayer(gradientLayer, at: 0)
            }
        } else {
            separatorView.backgroundColor = .clear
        }
    }
    
    
    //MARK:- Set Category and Result images
    
    /**
     Category Image corresponds to the left most image in the TextField
     
     - Parameter imageName: Accepts an optional string value. The framework first searches the image with the specified name in the main project bundle, if it is unable to find, it will search inside the framework bundle.
     - Parameter imageColor: Optional UIColor for the image. If the color is not passed, the image will be displayed in the original color
     */
    public func setCategoryImage(withImageName imageName: String?, imageColor: UIColor? = nil, image: UIImage? = nil) {
        
        if let image = image {
            categoryImageView.image = image
            categoryImageLeadingConstraint.constant = 16.0
            categoryImageViewWidth.constant = 24.0
        } else if imageName == nil {
            categoryImageLeadingConstraint.constant = 0.0
            categoryImageViewWidth.constant = 0.0
        } else {
            categoryImageView.image = UIImage().getImage(named: imageName)
            categoryImageLeadingConstraint.constant = 16.0
            categoryImageViewWidth.constant = 24.0
        }
        
        if let imageColor = imageColor {
            categoryImageView.tintColor = imageColor
        }
    }
    
    /**
     Result Image corresponds to the right most image in the TextField (this has an action associated with it)
     
     - Parameter imageName: Accepts an optional string value. The framework first searches the image with the specified name in the main project bundle, if it is unable to find, it will search inside the framework bundle.
     - Parameter imageColor: Optional UIColor for the image. If the color is not passed, the image will be displayed in the original color
     */
    public func setResultImage(withImageName imageName: String?, imageColor: UIColor? = nil, image: UIImage? = nil) {
        
        resultButton.imageView?.contentMode = .scaleAspectFit
        
        if let image = image {
            resultButton.setImage(image, for: .normal)
            resultButtonWidth.constant = 24.0
            textFieldTrailingConstraint.constant = rightContainerButton.bounds.width + 16.0
            resultButton.isUserInteractionEnabled = true
        } else if imageName == nil {
            resultButtonWidth.constant = 0.0
            resultButton.isUserInteractionEnabled = false
            textFieldTrailingConstraint.constant = 10.0
        } else {
            resultButton.setImage(UIImage().getImage(named: imageName), for: .normal)
            resultButtonWidth.constant = 24.0
            resultButton.isUserInteractionEnabled = true
            textFieldTrailingConstraint.constant = rightContainerButton.bounds.width + 16.0
        }
        setRightContainerButtonConstraint()
        
        if let imageColor = imageColor {
            resultButton.tintColor = imageColor
        }
    }
    
    private func setRightContainerButtonConstraint(){
        if (toggleButton.isHidden == false || resultButtonWidth.constant != 0){
            rightContainerButtonTrailingConstraint.constant = 16
            return
        }
        rightContainerButtonTrailingConstraint.constant = 0
        return
    }
    
    //MARK:- UITextField delegates
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.delegate?.textFieldShouldBeginEditing(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidBeginEditing(textField, parent: self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing(textField, parent: self)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.delegate?.textFieldShouldClear(textField, parent: self) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.delegate?.textFieldShouldReturn(textField, parent: self) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.delegate?.textFieldDidEndEditing(textField, reason: reason, parent: self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.delegate?.textFieldShouldEndEditing(textField, parent: self) ?? true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.length == 0, let text = textField.text, (text + string).count > maxAllowedCharacters {
            return false
        }
        return self.delegate?.textField(textField, shouldChangeCharactersIn: range, replacementString: string, parent: self) ?? true
    }
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        if let newLength = textField.text?.count, newLength == 0 {
            self.placeholderLabel.attributedText = nil
        } else {
            self.placeholderLabel.attributedText = placeholderText
        }
        delegate?.textFieldDidChange(textField: textField, parent: self)
        
    }
    
    //MARK:- Actions
    @IBAction func didTapRightButton(_ sender: UIButton) {
        self.delegate?.didTapRightButton(sender: sender, parent: self)
    }
}
