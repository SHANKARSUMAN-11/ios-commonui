//
//  CustomAlertViewController.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 22/03/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public enum AlertType: String, Codable {
    case info = "info"
    case warning = "warning"
    case error = "error"
    case success = "success"
    case custom = "custom"
}

public protocol CustomAlertDelegate: class {
    func didTapRightButton(sender: Any, parent: Any)
    func didTapLeftButton(sender: Any, parent: Any)
    func didTapTitleLabel(sender: Any, parent: Any)
    func didTapDescriptionLabel(sender: Any, parent: Any)
}

public extension CustomAlertDelegate {
    func didTapRightButton(sender: Any, parent: Any) {}
    func didTapLeftButton(sender: Any, parent: Any) {}
    func didTapTitleLabel(sender: Any, parent: Any) {}
    func didTapDescriptionLabel(sender: Any, parent: Any) {}
}

public class CustomAlertViewController: UIViewController {

    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var masterView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet public weak var backgroundView: UIView!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageToTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageToStackViewConstraint: NSLayoutConstraint!
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleToDescriptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet public weak var rightButton: CustomButton!
    @IBOutlet public weak var leftButton: CustomButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var verticalButton: CustomButton!
    @IBOutlet weak var buttonVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var buttonsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var alertLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertTrailingConstraint: NSLayoutConstraint!
    
    
    public var delegate: CustomAlertDelegate?
    public var rightButtonAction: ((UIButton) -> Void)?
    public var leftButtonAction: ((UIButton) -> Void)?
    public var closeButtonAction: ((UIButton) -> Void)?
    
    var component: Component.Alert? = nil
    var _image: UIImage?
    var _title: String? = nil
    var _description: String? = nil
    var _rightButtonTitle: String? = nil
    var _leftButtonTitle: String? = nil
    var _attributedTitle: NSAttributedString? = nil
    var _attributedDescription: NSAttributedString? = nil
    var _attributedRightButtonTitle: NSAttributedString? = nil
    var _attributedLeftButtonTitle: NSAttributedString? = nil
    var _imagePosition: Position = .left
    var _imageColor: UIColor? = nil
    var _statusColor: UIColor? = .clear
    var _alertType: AlertType = .info
    var _shouldAutoDismiss: Bool = false
    var _buttonType = Type(rawValue: 2)!
    var _buttonPosition: Position = .right
    var leading = NSLayoutConstraint()
    var _textAlignment: NSTextAlignment = .left
    var _stackView: UIStackView? = nil
    var _shouldShowCloseButton: Bool = false
    var alertBuilder: AlertBuilder?
    var _backgroundColor: UIColor = .white
    var _alpha: CGFloat = 1.0
    var _dismissTime: Double = 0.5
    var _alertViewHeight: CGFloat? = nil
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public convenience init() {
        self.init(nibName: "CustomAlertViewController", bundle: Bundle(for: CustomAlertViewController.self))
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .allButUpsideDown
        }
        return .portrait
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
        component = Configuration.shared.getComponent()?.Alert
        
        self.backgroundView.layer.backgroundColor = component?.getBackgroundColor().cgColor
        self.backgroundView.layer.borderColor = component?.getBorderColor().cgColor
        self.backgroundView.layer.borderWidth = component?.borderWidth ?? kDefaultBorderWidth
        self.backgroundView.layer.cornerRadius = component?.cornerRadius ?? kDefaultCornerRadius
        self.backgroundView.backgroundColor = _backgroundColor
        
        if let height = _alertViewHeight {
            self.backgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let constant = UIScreen.main.bounds.width / 4
            alertLeadingConstraint.constant = constant
            alertTrailingConstraint.constant = constant
        }
        
        self.titleLabel?.font = UIFont(name: "EffraMedium-Regular", size: 20.0)
        self.descriptionLabel?.font = UIFont(name: "Effra-Regular", size: 14.0)
        
        if let attributedTitle = _attributedTitle {
            self.titleLabel?.attributedText = attributedTitle
        } else {
            self.titleLabel?.text = _title
        }
        
        if let attributedDescription = _attributedDescription {
            self.descriptionLabel?.attributedText = attributedDescription
        } else {
            self.descriptionLabel?.text = _description
        }
        
        if let alertBuilder = alertBuilder {
            titleLabel.alpha = alertBuilder.titleAlpha
            descriptionLabel.alpha = alertBuilder.descriptionAlpha
        }
        
        if let title = _attributedRightButtonTitle {
            self.rightButton.setAttributedTitle(title, for: .normal)
            self.rightButton?.isHidden = false
        } else if let title = _rightButtonTitle {
            self.rightButton?.setTitle(title, for: .normal)
            self.rightButton?.isHidden = false
        } else {
            self.rightButton.isHidden = true
        }
        
        if let title = _attributedLeftButtonTitle {
            self.leftButton.setAttributedTitle(title, for: .normal)
            self.leftButton?.isHidden = false
        } else if let title = _leftButtonTitle {
            self.leftButton?.setTitle(title, for: .normal)
            self.verticalButton?.setTitle(title, for: .normal)
            self.leftButton?.isHidden = false
        } else {
            removeLeftButton()
        }
        
        leftButton.type = _buttonType.rawValue
        rightButton.type = _buttonType.rawValue
        verticalButton.type = _buttonType.rawValue
        
        configureAlert()
        configureStackView()
        
        alignImage(at: _imagePosition)
        
        if #available(iOS 11.0, *) {
            UIView.animate(withDuration: 0.1, animations: {
                self.masterView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { (finished) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.masterView.transform = CGAffineTransform.identity
                })
            }
        }
 
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapTitleLabel(_:)))
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(tap)
        
        let tap_description = UITapGestureRecognizer(target: self, action: #selector(self.didTapDescriptionLabel(_:)))
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(tap_description)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        alignButtons()
        if _shouldAutoDismiss {
            autoDismissAlert()
        }
    }
    
    public func createAlert(with details: AlertBuilder) {
        _attributedTitle = details.attributedTitle
        _attributedDescription = details.attributedDescription
        _attributedLeftButtonTitle = details.attributedLeftButtonTitle
        _attributedRightButtonTitle = details.attributedRightButtonTitle
        _title = details.title
        _description = details.description
        _rightButtonTitle = details.rightButtonTitle
        _leftButtonTitle = details.leftButtonTitle
        _alertType = details.alertType
        _imagePosition = details.imagePosition
        _shouldAutoDismiss = details.shouldAutoDismiss
        _buttonType = details.buttonType
        _image = details.image
        _buttonPosition = details.buttonPosition
        _textAlignment = details.textAlignment
        _imageColor = details.imageColor
        _statusColor = details.statusColor
        _stackView = details.stackView
        _shouldShowCloseButton = details.shouldShowCloseButton
        _backgroundColor = details.backgroundColor
        _alpha = details.alertAlpha
        _dismissTime = details.dismissTime
        _alertViewHeight = details.alertViewHeight
        alertBuilder = details
    }
    
    func alignButtons() {
        
        if buttonsView.frame.origin.x < 0 || buttonsView.frame.width > backgroundView.frame.width {
            removeLeftButton()
            
            if _rightButtonTitle != nil {
                rightButton.isHidden = false
            }
            
            if _leftButtonTitle != nil {
                verticalButton.isHidden = false
                buttonVerticalSpacing.constant = 12.0
            }
            
        } else {
            
            if _leftButtonTitle != nil {
                leftButton.isHidden = false
            }
            
            if _rightButtonTitle != nil {
                rightButton.isHidden = false
            }
            verticalButton.isHidden = true
            
            var viewRect = verticalButton.frame
            viewRect.size.height = 0
            verticalButton.frame = viewRect
            
            if _leftButtonTitle == nil, _rightButtonTitle == nil {
                buttonsViewHeightConstraint.constant = 0
                buttonVerticalSpacing.constant = -40
            } else {
                buttonsViewHeightConstraint.constant = 32
                buttonVerticalSpacing.constant = -40
            }
        }
        
        alignButton(at: _buttonPosition)
    }
    
    func removeLeftButton() {
        var viewRect = leftButton.frame
        viewRect.size.width = 0
        leftButton.frame = viewRect
        self.leftButton.isHidden = true
        self.verticalButton.isHidden = true
        buttonVerticalSpacing.constant = -20
        buttonSpacingConstraint.constant = 0
        
        let leading = NSLayoutConstraint(item: buttonsView, attribute: .leading, relatedBy: .equal, toItem: getObject(), attribute: .leading, multiplier: 1, constant: -24.0)
        let trailing = NSLayoutConstraint(item: buttonsView, attribute: .trailing, relatedBy: .equal, toItem: getObject(), attribute: .trailing, multiplier: 1, constant: 24.0)
        
        NSLayoutConstraint.activate([leading, trailing])
    }
    
    func getStateConfig(for state: AlertType) -> Component.Alert.Status? {
        return component?.status?.filter({ $0.type == state }).first
    }
    
    fileprivate func configureAlert() {
        
        var image_: UIImage? = nil
        var imageColor_: UIColor? = nil
        
        switch _alertType {
        case .warning:
            if let warningStatusConfig = getStateConfig(for: .warning) {
                _statusColor = warningStatusConfig.getStatusColor()
                
                if let image = warningStatusConfig.statusImage {
                    image_ = UIImage(named: image, in: Bundle(for: type(of: self)), compatibleWith: nil)
                    
                    if let imageTint = warningStatusConfig.getImageTintColor() {
                        imageColor_ = imageTint
                    }
                }
            }
        case .error:
            if let errorStatusConfig = getStateConfig(for: .error) {
                _statusColor = errorStatusConfig.getStatusColor()
                
                if let image = errorStatusConfig.statusImage {
                    image_ = UIImage(named: image, in: Bundle(for: type(of: self)), compatibleWith: nil)
                    
                    if let imageTint = errorStatusConfig.getImageTintColor() {
                        imageColor_ = imageTint
                    }
                }
            }
        case .success:
            if let successStatusConfig = getStateConfig(for: .success) {
                _statusColor = successStatusConfig.getStatusColor()
                
                if let image = successStatusConfig.statusImage {
                    image_ = UIImage(named: image, in: Bundle(for: type(of: self)), compatibleWith: nil)
                    
                    if let imageTint = successStatusConfig.getImageTintColor() {
                        imageColor_ = imageTint
                    }
                }
            }
        case .info:
            if let infoStatusConfig = getStateConfig(for: .info) {
                _statusColor = infoStatusConfig.getStatusColor()
                
                if let image = infoStatusConfig.statusImage {
                    image_ = UIImage(named: image, in: Bundle(for: type(of: self)), compatibleWith: nil)
                    
                    if let imageTint = infoStatusConfig.getImageTintColor() {
                        imageColor_ = imageTint
                    }
                }
            }
        case .custom:
            if let customStatusConfig = getStateConfig(for: .custom) {
                
                if let image = customStatusConfig.statusImage {
                    image_ = UIImage(named: image, in: Bundle(for: type(of: self)), compatibleWith: nil)
                    
                    if let imageTint = customStatusConfig.getImageTintColor() {
                        imageColor_ = imageTint
                    }
                }
            }
        }
        
        if #available(iOS 11.0, *) {
            self.statusView.clipsToBounds = true
            self.statusView.layer.cornerRadius = 8
            self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.statusView.backgroundColor = _statusColor
        } else {
            // iOS 10 does not support masked corners.
            self.statusView.backgroundColor = .clear
        }
        
        self.imageView.image = _image ?? image_
        
        if let image = _image ?? image_ {
            imageViewTopConstraint.constant = 28.0
            imageToTitleConstraint.constant = 28.0
            imageToStackViewConstraint.constant = 28.0
            
            if let color = _imageColor ?? imageColor_ {
                imageView.image = image.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = color
            }
        } else {
            imageViewTopConstraint.constant = 0.0
            imageToTitleConstraint.constant = 0.0
            imageToStackViewConstraint.constant = 0.0
            imageView.image = nil
        }
        
        titleLabel.textAlignment = _textAlignment
        descriptionLabel.textAlignment = _textAlignment
        closeButton.isHidden = !_shouldShowCloseButton
        
        if _title == nil, _attributedTitle == nil {
            titleToDescriptionConstraint.constant = 0.0
        } else {
            titleToDescriptionConstraint.constant = 8.0
        }
    }
    
    func configureStackView() {
        
        if let stackView_ = _stackView {
            titleLabel.text = nil
            titleLabel.attributedText = nil
            descriptionLabel.text = nil
            descriptionLabel.attributedText = nil
            
            stackView.isHidden = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            for view in stackView.arrangedSubviews {
                stackView.removeArrangedSubview(view)
            }
        
            for (index, view) in stackView_.arrangedSubviews.enumerated() {
                view.sizeToFit()
                view.layoutIfNeeded()
                stackView.insertArrangedSubview(view, at: index)
            }            
        }
    }

    func alignImage(at position: Position) {
        
        switch position {
        case .right:
            let y = NSLayoutConstraint(item: imageView, attribute: .trailing , relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: -24)
            NSLayoutConstraint.activate([y])
            
        case .center:
            let y = NSLayoutConstraint(item: imageView, attribute: .centerX , relatedBy: .equal, toItem: backgroundView, attribute: .centerX, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([y])
            
        default:
            let y = NSLayoutConstraint(item: backgroundView, attribute: .leading , relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: -24)
            NSLayoutConstraint.activate([y])
        }
    }
    
    func getObject() -> Any {
        return leftButton.isHidden ? rightButton as Any : leftButton as Any
    }
    
    func alignButton(at position: Position) {
        
        switch position {
        case .center:
            let center = NSLayoutConstraint(item: buttonsView, attribute: .centerX, relatedBy: .equal, toItem: backgroundView, attribute: .centerX, multiplier: 1, constant: 0)
            let buttonCenter = NSLayoutConstraint(item: verticalButton, attribute: .centerX, relatedBy: .equal, toItem: backgroundView, attribute: .centerX, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([center, buttonCenter])
        
        case .left:
            let leading = NSLayoutConstraint(item: buttonsView, attribute: .leading, relatedBy: .equal, toItem: getObject(), attribute: .leading, multiplier: 1, constant: -24.0)
            let buttonleading = NSLayoutConstraint(item: verticalButton, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: 24.0)
            NSLayoutConstraint.activate([leading, buttonleading])
            
            var viewRect = buttonsView.frame
            viewRect.origin.x = 0
            buttonsView.frame = viewRect
            
        default:
            let trailing = NSLayoutConstraint(item: buttonsView, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: 0.0)
            let buttontrailing = NSLayoutConstraint(item: verticalButton, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: -24.0)
            NSLayoutConstraint.activate([trailing, buttontrailing])
            
            var viewRect = buttonsView.frame
            viewRect.origin.x = backgroundView.frame.width - viewRect.width
            buttonsView.frame = viewRect

        }
    }
    
    func autoDismissAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + _dismissTime) {
            self.dismiss(animated: true, completion: self.alertBuilder?.completion)
        }
    }
    
    public func setHelperLabelFont(withFont font: UIFont?) {
        titleLabel.font = font
    }
    
    public func setTextFieldFont(withFont font: UIFont?) {
        descriptionLabel.font = font
    }
    
    public func setBackgroundColor(withColor color: UIColor) {
        backgroundView.backgroundColor = color
    }
    
    public func setTextAlignment(withAlignment alignment: NSTextAlignment) {
        titleLabel.textAlignment = alignment
        descriptionLabel.textAlignment = alignment
    }
    
    @objc func didTapTitleLabel(_ sender: UITapGestureRecognizer) {
        delegate?.didTapTitleLabel(sender: titleLabel, parent: self)
    }
    
    @objc func didTapDescriptionLabel(_ sender: UITapGestureRecognizer) {
        delegate?.didTapDescriptionLabel(sender: descriptionLabel, parent: self)
    }
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        dismiss(animated: false) {
            self.rightButtonAction?(sender)
            self.delegate?.didTapRightButton(sender: sender, parent: self)
        }
    }
    
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        dismiss(animated: false) {
            self.leftButtonAction?(sender)
            self.delegate?.didTapLeftButton(sender: sender, parent: self)
        }
    }
    
    @IBAction func didTapDismissButton(_ sender: UIButton) {
        if _shouldAutoDismiss {
            dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        self.closeButtonAction?(sender)
    }
    
    //MARK:- Deprecated methods
    
    @available(*, deprecated, message: "Please use `createAlert(with details: AlertBuilder)` method instead")
    public func createAlert(title: String?, description: String?, imagePosition: Position = .left,  rightButtonTitle: String? = nil, leftButtonTitle: String? = nil, statusImage: UIImage? = nil, imageTint: UIColor? = nil, alertType: AlertType = .info, shouldAutoDismiss: Bool = true, buttonType: Type = .ghost, buttonPosition: Position = .right, textAlignment: NSTextAlignment = .left, statusColor: UIColor = .clear, stackView: UIStackView? = nil, dismissTime: Double = 1.0, alertViewHeight: CGFloat? = nil) {
        _title = title
        _description = description
        _rightButtonTitle = rightButtonTitle
        _leftButtonTitle = leftButtonTitle
        _alertType = alertType
        _imagePosition = imagePosition
        _shouldAutoDismiss = shouldAutoDismiss
        _buttonType = buttonType
        _image = statusImage
        _buttonPosition = buttonPosition
        _textAlignment = textAlignment
        _imageColor = imageTint
        _statusColor = statusColor
        _stackView = stackView
        _dismissTime = dismissTime
        _alertViewHeight = alertViewHeight
    }
    
    @available(*, deprecated, message: "Please use `createAlert(with details: AlertBuilder)` method instead")
    public func createAlert(attributedTitle: NSAttributedString?, attributedDescription: NSAttributedString?, imagePosition: Position = .left,  attributedRightButtonTitle: NSAttributedString? = nil, attributedLeftButtonTitle: NSAttributedString? = nil, statusImage: UIImage? = nil, imageTint: UIColor? = nil, alertType: AlertType = .info, shouldAutoDismiss: Bool = true, buttonType: Type = .ghost, buttonPosition: Position = .right, textAlignment: NSTextAlignment = .left, statusColor: UIColor = .clear, stackView: UIStackView? = nil, dismissTime: Double = 1.0, alertViewHeight: CGFloat? = nil) {
        _attributedTitle = attributedTitle
        _attributedDescription = attributedDescription
        _attributedRightButtonTitle = attributedRightButtonTitle
        _attributedLeftButtonTitle = attributedLeftButtonTitle
        _alertType = alertType
        _imagePosition = imagePosition
        _shouldAutoDismiss = shouldAutoDismiss
        _buttonType = buttonType
        _image = statusImage
        _buttonPosition = buttonPosition
        _textAlignment = textAlignment
        _imageColor = imageTint
        _statusColor = statusColor
        _stackView = stackView
        _dismissTime = dismissTime
        _alertViewHeight = alertViewHeight
    }
}

public class AlertBuilder {
    
    public var title: String?
    public var description: String?
    public var image: UIImage?
    public var rightButtonTitle: String? = nil
    public var leftButtonTitle: String? = nil
    public var attributedTitle: NSAttributedString? = nil
    public var attributedDescription: NSAttributedString? = nil
    public var attributedRightButtonTitle: NSAttributedString? = nil
    public var attributedLeftButtonTitle: NSAttributedString? = nil
    public var imagePosition: Position = .left
    public var imageColor: UIColor? = nil
    public var statusColor: UIColor? = .clear
    public var alertType: AlertType = .info
    public var shouldAutoDismiss: Bool = true
    public var buttonType = Type(rawValue: 2)!
    public var buttonPosition: Position = .right
    public var leading = NSLayoutConstraint()
    public var textAlignment: NSTextAlignment = .left
    public var stackView: UIStackView? = nil
    public var shouldShowCloseButton: Bool = false
    public var titleAlpha: CGFloat = 0.87
    public var descriptionAlpha: CGFloat = 0.38
    public var backgroundColor: UIColor = .white
    public var alertAlpha: CGFloat = 1.0
    public var dismissTime: Double = 0.5
    public var alertViewHeight: CGFloat? = nil
    public var completion: (() -> Void)?
    
    public typealias closure = (AlertBuilder) -> Void
    
    public init(build: closure) {
        build(self)
    }
}
