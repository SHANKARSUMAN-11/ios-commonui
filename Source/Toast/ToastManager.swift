//
//  ToastManager.swift
//  CommonUIKit
//
//  Created by Prince Mathew on 27/02/19.
//  Copyright © 2019 Coviam. All rights reserved.
//
/**
 `ToastManager` provides general configuration options for all toast
 notifications. Backed by a singleton instance.
 */

import Foundation

public class ToastManager {
    
    /**
     The `ToastManager` singleton instance.
     
     */
    public static let shared = ToastManager()
    
    /**
     The shared style. Used whenever toastViewForMessage(message:title:image:style:) is called
     with with a nil style.
     
     */
    public var style = ToastStyle()
    
    
    /**
     Enables or disables the auto dismiss of toast views. Default is `true`.
     */
    public var shouldAutoDismiss = true
    
    /**
     Enables or disables tap to dismiss on toast views. Default is `true`.
     */
    public var isTapToDismissEnabled = true
    
    /**
     Enables or disables queueing behavior for toast views. When `true`,
     toast views will appear one after the other. When `false`, multiple toast
     views will appear at the same time (potentially overlapping depending
     on their positions). This has no effect on the toast activity view,
     which operates independently of normal toast views. Default is `false`.
     
     */
    public var isQueueEnabled = false
    
    /**
     The default duration. Used for the `makeToast` and
     `showToast` methods that don't require an explicit duration.
     Default is 3.0.
     
     */
    public var duration: TimeInterval = 3.0
    
    /**
     Sets the default position. Used for the `makeToast` and
     `showToast` methods that don't require an explicit position.
     Default is `ToastPosition.Bottom`.
     
     */
    public var position: ToastPosition = .bottom
    
}

// MARK: - ToastPosition
public enum ToastPosition {
    case top
    case center
    case bottom
    
    public func centerPoint(forToast toast: UIView, inSuperview superview: UIView) -> CGPoint {
        
        let topPadding: CGFloat = ToastManager.shared.style.verticalPadding + superview.csSafeAreaInsets.top
        let bottomPadding: CGFloat = ToastManager.shared.style.verticalPadding + superview.csSafeAreaInsets.bottom
        
        switch self {
        case .top:
            return CGPoint(x: superview.bounds.size.width / 2.0, y: (toast.frame.size.height / 2.0) + topPadding)
        case .center:
            return CGPoint(x: superview.bounds.size.width / 2.0, y: superview.bounds.size.height / 2.0)
        case .bottom:
            return CGPoint(x: superview.bounds.size.width / 2.0, y: (superview.bounds.size.height - (toast.frame.size.height / 2.0)) - bottomPadding - ToastManager.shared.style.bottomSpaceToSuperView)
        }
    }
}

fileprivate extension UIView {
    
    fileprivate var csSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return .zero
        }
    }
    
}

