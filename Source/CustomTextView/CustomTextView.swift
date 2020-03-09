//
//  CustomTextView.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 12/03/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public protocol CustomTextViewDelegate: class {
    func didTapRightButton(sender: Any, parent: Any)
    func textViewDidChange(_ textView: UITextView, parent: Any)
    func textViewShouldBeginEditing(_ textView: UITextView, parent: Any) -> Bool
    func textViewDidBeginEditing(_ textView: UITextView, parent: Any)
    func textViewDidEndEditing(_ textView: UITextView, parent: Any)
    func textViewShouldEndEditing(_ textView: UITextView, parent: Any) -> Bool
    func textViewDidChangeSelection(_ textView: UITextView, parent: Any)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, parent: Any) -> Bool
}

public extension CustomTextViewDelegate {
    func didTapRightButton(sender: Any, parent: Any) {}
    func textViewDidChange(_ textView: UITextView, parent: Any) {}
    func textViewShouldBeginEditing(_ textView: UITextView, parent: Any) -> Bool { return true }
    func textViewDidBeginEditing(_ textView: UITextView, parent: Any) {}
    func textViewDidEndEditing(_ textView: UITextView, parent: Any) {}
    func textViewShouldEndEditing(_ textView: UITextView, parent: Any) -> Bool { return true }
    func textViewDidChangeSelection(_ textView: UITextView, parent: Any) {}
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, parent: Any) -> Bool { return true }
}

open class CustomTextView: UIView, UITextViewDelegate {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet public var placeholderLabel: UILabel!
    @IBOutlet public weak var textView: UITextView!
    @IBOutlet public weak var helperLabel: UILabel!
    @IBOutlet public weak var helperLabelHeight: NSLayoutConstraint!
    
    @IBOutlet public weak var categoryImageView: UIImageView!
    @IBOutlet public weak var categoryImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet public weak var categoryImageViewWidth: NSLayoutConstraint!
    //@IBOutlet weak var placeholerLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet public weak var resultButton: UIButton!
    @IBOutlet public weak var resultButtonWidth: NSLayoutConstraint!
    @IBOutlet public weak var resultButtonTrailingConstraint: NSLayoutConstraint!
    
    public weak var delegate: CustomTextViewDelegate? = nil
    
    internal var component: Component.TextView?
    private var cursorOffset: Int = 1
    
    var isEditing = false
    private var cursorPosition: UITextRange?
    
    ///Border Color of the complete Custom Text View. The Custom TextView includes the textView and the Placeholder label, excludes the helper label. Default is set to clear color
    public var borderColor_: UIColor? = .clear {
        didSet {
            self.backgroundView.layer.borderColor = self.borderColor_?.cgColor
        }
    }
    
    ///Border Width of the complete Custom Text View. The Custom TextView includes the TextView and the Placeholder label, excludes the helper label. Default is set to 0
    public var borderWidth_: CGFloat = 0.0 {
        didSet {
            self.backgroundView.layer.borderWidth = self.borderWidth_
        }
    }
    
    ///Corner Radius of the complete Custom Text View. The Custom TextView includes the TextView and the Placeholder label, excludes the helper label. Default is set to 0
    public var cornerRadius_: CGFloat = 0.0 {
        didSet {
            self.backgroundView.layer.cornerRadius = self.cornerRadius_
        }
    }
    
    ///Background Color of the complete Custom Text View. The Custom TextView includes the TextView and the Placeholder label, excludes the helper label. Default is set to clear color
    public var backgroundColor_: UIColor? = .clear {
        didSet {
            self.view.backgroundColor = self.backgroundColor_
        }
    }
    
    ///The state of the TextField / TextView. Based on the state value and if the -shouldUpdateFieldsForStateChange boolean is set, Placeholder text color, helper label text color and the textView / textView border color will be changed
    public var state: TextAreaState = .plain {
        didSet {
            self.configureTextView(for: state)
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
    
    ///Background Color of the TextView. To set the background color for the complete view, use -backgroundColor_ property
    public var textViewBackgroundColor: UIColor? = .clear {
        didSet {
            self.backgroundView.backgroundColor = self.textViewBackgroundColor
        }
    }
    
    ///Sets the textView text. Use this to set the text, text color, font etc. This attribure should be set after setting up the -placeholderText property
    public var textViewText: NSAttributedString? = nil {
        didSet {
            self.calculateTextViewAttributes(from: textViewText)
            self.setText()
        }
    }
    
    ///Sets the Placeholder label text. Use this to set the text, text color, font etc
    public var placeholderText: NSAttributedString? = nil {
        didSet {
            self.setText()
        }
    }
    
    ///Sets the textView text. Use this to set the text, text color, font etc
    public var helperText: NSAttributedString? = nil {
        didSet {
            self.helperLabel.attributedText = helperText
        }
    }
    
    ///Sets the textView text alignment. Default is set to left aligned
    public var textViewTextAlignment: NSTextAlignment = .left {
        didSet {
            self.textView.textAlignment = textViewTextAlignment
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
    
    ///Active State indicates that the textView has became the firstResponder. When the textView is being edited, this color will be applied to the fields. If -shouldUpdateFieldsForStateChange property is set to true, the color will be applied to placeholder label, border color, helper label and the result button image
    public var activeStateColor: UIColor = .clear
    
    
    ///Default State indicates that the textView is visible but not being edited now. If -shouldUpdateFieldsForStateChange property is set to true, the color will be applied to placeholder label, border color, helper label and the result button image
    public var defaultStateColor: UIColor = .clear
    
    
    ///Success State indicates that the textView has resigned from the firstResponder. When the textView is done editing and all the validations are successful, this color will be applied to the fields. If -shouldUpdateFieldsForStateChange property is set to true, the color will be applied to placeholder label, border color, helper label and the result button image
    public var successStateColor: UIColor = .clear
    
    
    ///Error State indicates that the textView has resigned from the firstResponder. When the textView is done editing and some of the validations are unsuccessful, this color will be applied to the fields. If -shouldUpdateFieldsForStateChange property is set to true, the color will be applied to placeholder label, border color, helper label and the result button image
    public var errorStateColor: UIColor = .clear
    
    
    ///The boolean variable that indicates whether the state change should change the color of the fields or not. If set to true, the state change color will be applied to placeholder label, border color, helper label and the result button image. Default is set to true
    public var shouldUpdateFieldsForStateChange: Bool = true
    
    
    ///The helper label number of lines to be displayed. Default number of line(s) is 1
    public var helperLabelNumberOfLines: Int = 1 {
        didSet {
            self.helperLabel.numberOfLines = helperLabelNumberOfLines
        }
    }
    
    /**
     Calculates the necessary textView parameters. -textViewFont and -textViewTextColor from the NSAttributedString. The method will loop through the attributed string to read the above said values
     
     - Parameter text: The NSAttributedString from which the parameters to be calculated
     */
    func calculateTextViewAttributes(from text: NSAttributedString? = nil) {
        
        if let text = text, !text.string.isEmpty {
            
            for attribute in text.attributes(at: 0, effectiveRange: nil) {
                
                if attribute.key == NSAttributedString.Key.font {
                    self.textViewFont = attribute.value as? UIFont
                    
                } else if attribute.key == NSAttributedString.Key.foregroundColor {
                    self.textViewTextColor = attribute.value as? UIColor
                }
            }
        }
    }
    
    var textViewFont: UIFont? = nil
    var textViewTextColor: UIColor?
    
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
        let nib = UINib(nibName: "CustomTextView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        
        component = Configuration.shared.getComponent()?.TextView
        self.textViewFont = self.textView.font
        self.textViewTextColor = self.textView.textColor ?? UIColor.black.withAlphaComponent(0.6)
        self.backgroundColor_ = component?.getBackgroundColor()
        self.borderColor_ = component?.getBorderColor()
        self.borderWidth_ = component?.borderWidth ?? kDefaultBorderWidth
        self.cornerRadius_ = component?.cornerRadius ?? kDefaultCornerRadius
        self.state = .plain
        self.helperLabelNumberOfLines = 2
//        self.placeholderText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont(name: "Effra-Regular", size: 12.0) as Any])
//        self.textFieldText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont(name: "EffraMedium-Regular", size: 16.0) as Any])
        
        self.setCategoryImage(withImageName: nil)
        self.setResultImage(withImageName: nil)
        
        self.textView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView))
            backgroundView.addGestureRecognizer(tapGesture)
    }
        
    @objc func didTapTextView(_ sender: UITapGestureRecognizer) {
        textView.becomeFirstResponder()
    }
    
    public func setTextViewTag(withTag tag: Int) {
        self.textView.tag = tag
    }
    
    /**
     Automatically handles the TextField text and the placeholder text.
     
     1. If the textFieldText is nil, then the textField's placeholder is set and the placeholder text is set to nil
     2. Else, the placeholder and the textField is set to its respective values
     */
    func setText() {
        
        DispatchQueue.main.async {
            if self.textViewText == nil || self.textViewText?.string.isEmpty ?? true {
                self.textView.attributedText = NSAttributedString(string: self.placeholderText?.string ?? "", attributes: [NSAttributedString.Key.foregroundColor: self.textViewTextColor as Any, NSAttributedString.Key.font:
                    self.textViewFont as Any])
                self.placeholderLabel.attributedText = nil
                
            } else {
                self.textView.attributedText = NSAttributedString(string: self.textViewText?.string ?? "", attributes: [NSAttributedString.Key.foregroundColor: self.textViewTextColor as Any, NSAttributedString.Key.font:
                    self.textViewFont as Any])
                self.placeholderLabel.attributedText = self.placeholderText
            }
            self.setCursor()
        }
    }
    
    func setCursor() {
        guard let position = self.cursorPosition, let newPosition = self.textView.position(from: position.start, offset: self.cursorOffset) else {return}
        self.textView.selectedTextRange = self.textView.textRange(from: newPosition, to: newPosition)
    }
    
    /**
     Configures the TextView with different state values
     - Parameter state: The state of the TextView
     - seeAlso: TextAreaState
     */
    func configureTextView(for state: TextAreaState) {
        
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
    
    //MARK:- Set Category and Result images
    
    public func setRightButtonPosition(position: Position) {
        
        switch position {
        case .top:
            let image = NSLayoutConstraint(item: resultButton, attribute: .top , relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 16)
            NSLayoutConstraint.activate([image])
        case .bottom:
            let image = NSLayoutConstraint(item: resultButton, attribute: .bottom , relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: -16)
            NSLayoutConstraint.activate([image])
        default:
            let image = NSLayoutConstraint(item: backgroundView, attribute: .centerY , relatedBy: .equal, toItem: resultButton, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([image])
        }
    }
    
    public func setCategoryImage(withImageName imageName: String?, imageColor: UIColor? = nil) {
        
        if imageName == nil {
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
    
    public func setResultImage(withImageName imageName: String?, imageColor: UIColor? = nil) {
        resultButton.imageView?.contentMode = .scaleAspectFit
        if imageName == nil {
            resultButtonTrailingConstraint.constant = 0.0
            resultButtonWidth.constant = 0.0
            resultButton.isUserInteractionEnabled = false
        } else {
            resultButton.setImage(UIImage().getImage(named: imageName), for: .normal)
            resultButtonTrailingConstraint.constant = 16.0
            resultButtonWidth.constant = 24.0
            resultButton.isUserInteractionEnabled = true
        }
        
        if let imageColor = imageColor {
            resultButton.tintColor = imageColor
        }
    }

    //MARK:- Actions
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        self.delegate?.didTapRightButton(sender: sender, parent: self)
    }
    
    //MARK:- Delegates
    
    public func textViewDidChange(_ textView: UITextView) {
        self.delegate?.textViewDidChange(textView, parent: self)
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.delegate?.textViewShouldBeginEditing(textView, parent: self) ?? true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.delegate?.textViewDidBeginEditing(textView, parent: self)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.textViewDidEndEditing(textView, parent: self)
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return self.delegate?.textViewShouldEndEditing(textView, parent: self) ?? true
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text == placeholderText?.string, textView.selectedRange != NSMakeRange(0, 0) {
            textView.selectedRange = NSMakeRange(0,0)
        }
        self.delegate?.textViewDidChangeSelection(textView, parent: self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print(#function)
        
        self.cursorPosition = textView.selectedTextRange
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if currentText.count < updatedText.count {
            self.cursorOffset = 1
        } else {
            self.cursorOffset = -1
        }
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            state = .plain
            textViewText = nil
            self.setText()
            
        } else if self.textViewText == nil || (self.textViewText?.string.isEmpty)! {
            self.textViewText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: self.textViewTextColor as Any, NSAttributedString.Key.font:
                self.textViewFont as Any])
            self.setText()
            
        } else if updatedText.count > maxAllowedCharacters {
            return false
            
        } else if self.textViewText != nil {
            self.textViewText = NSAttributedString(string: updatedText, attributes: [NSAttributedString.Key.foregroundColor: self.textViewTextColor as Any, NSAttributedString.Key.font:
                self.textViewFont as Any])
            self.setText()
            
        } else {
            return self.delegate?.textView(textView, shouldChangeTextIn: range, replacementText:text, parent: self) ?? true
        }
        _ = self.delegate?.textView(textView, shouldChangeTextIn: range, replacementText:text, parent: self)
        return false
    }
}



