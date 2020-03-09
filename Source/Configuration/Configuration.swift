//
//  Configuration.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 07/03/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit


let kDefaultCornerRadius:CGFloat = 0.0
let kDefaultBorderWidth:CGFloat = 1.0
let kDefaultShadowWidth:CGFloat = 0.0
let kDefaultThemeColor = "#0eb3ff"
let kDefaultBackgroundColor = "#ffffff"
let kDefaultBorderColor = "#000000"
let kDefaultTextColor = "#000000"
public let kDefaultFontSize:CGFloat = 14.0
let kDefaultPlaceholderTextColor = "#bdbdbd"
let kDefaultHelperTextColor = "#bdbdbd"
let kDefaultSelectedTextColor = "#ffffff"
let kDefaultSeparatorColor = "#00000000"
let kDefaultSeparatorHeight: CGFloat = 0.0
let kDefaultStatusColor = "#00000000"


public enum Position: Int {
    case top = 0
    case center
    case bottom
    case left
    case right
}

public class Configuration: NSObject {
    
    public static let shared = Configuration()

    private(set) var component: Component?
    
    public func setupConfiguration(fromPath path: String?) -> Configuration {
        
        if let path = path ?? Bundle(for: type(of: self)).path(forResource: "defaultConfiguration", ofType: "json") {
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                component = try decoder.decode(Component.self, from: data)
            }
            catch { print(error) }
        }
        
        //setupGlobalAppearance()
        
        return self
    }
    
    public func getComponent() -> Component? {
        return component
    }
}

extension KeyedDecodingContainer {
    subscript<T: Decodable>(key: KeyedDecodingContainer.Key) -> T? {
        if let value = try? decodeIfPresent(T.self, forKey: key){
            return value
        }
        return nil
    }
}

enum CodingKeys: String, CodingKey {
    case backgroundColor, borderColor, borderWidth, cornerRadius, textColor, shadowWidth, fontSize, placeholder, placeholderTextColor, helperTextColor, selectedTextColor, separatorColor, separatorHeight, statusColor, info, warning, error, success, statusImage, imageTint, status, types, buttonType, type, imageTintColor, selectedImageTintColor, tickerType
}

public struct Component : Codable {

    public struct Button: Codable {
        
        public var borderWidth: CGFloat
        public var shadowWidth: CGFloat
        public var cornerRadius: CGFloat
        
        public struct Types: Codable {
            var buttonType: Int?
            private var backgroundColor: String
            private var borderColor: String
            private var tintColor: String
            public var fontSize: CGFloat
            
            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                buttonType = values[.buttonType] ?? 0
                backgroundColor = values[.backgroundColor] ?? kDefaultBackgroundColor
                borderColor = values[.borderColor] ?? kDefaultBorderColor
                tintColor = values[.tintColor] ?? kDefaultTextColor
                fontSize = values[.fontSize] ?? kDefaultFontSize
            }
            
            public func getBackgroundColor() -> UIColor {
                return UIColor(hexString: backgroundColor)
            }
            
            public func getBorderColor() -> UIColor {
                return UIColor(hexString: borderColor)
            }
            
            public func getTintColor() -> UIColor {
                return UIColor(hexString: tintColor)
            }
        }
        
        public var types: [Types]?
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            borderWidth = values[.borderWidth] ?? kDefaultBorderWidth
            cornerRadius = values[.cornerRadius] ?? kDefaultCornerRadius
            shadowWidth = values[.shadowWidth] ?? kDefaultShadowWidth
            types = values[.types]
        }
    }
    
    public struct TextField: Codable {
        var backgroundColor: String
        var textColor: String
        var borderColor: String
        public var borderWidth: CGFloat
        public var shadowWidth: CGFloat
        public var cornerRadius: CGFloat
        public var fontSize: CGFloat
        public var placeholder: String?
        var placeholderTextColor: String
        var helperTextColor: String
        var separatorColor: String
        public var separatorHeight: CGFloat
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            backgroundColor = values[.backgroundColor] ?? kDefaultBackgroundColor
            textColor = values[.textColor] ?? kDefaultTextColor
            borderColor = values[.borderColor] ?? kDefaultBorderColor
            borderWidth = values[.borderWidth] ?? kDefaultBorderWidth
            shadowWidth = values[.shadowWidth] ?? kDefaultShadowWidth
            cornerRadius = values[.cornerRadius] ?? kDefaultCornerRadius
            fontSize = values[.fontSize] ?? kDefaultFontSize
            placeholder = values[.placeholder]
            placeholderTextColor = values[.placeholderTextColor] ?? kDefaultPlaceholderTextColor
            helperTextColor = values[.helperTextColor] ?? kDefaultHelperTextColor
            separatorColor = values[.separatorColor] ?? kDefaultSeparatorColor
            separatorHeight = values[.separatorHeight] ?? kDefaultSeparatorHeight
        }
        
        public func getTextColor() -> UIColor {
            return UIColor(hexString: textColor)
        }
        
        public func getBackgroundColor() -> UIColor {
            return UIColor(hexString: backgroundColor)
        }
        
        public func getBorderColor() -> UIColor {
            return UIColor(hexString: borderColor)
        }
        
        public func getPlaceHolderTextColor() -> UIColor {
            return UIColor(hexString: placeholderTextColor)
        }
        
        public func getHelperTextColor() -> UIColor {
            return UIColor(hexString: helperTextColor)
        }
        
        public func getSeparatorColor() -> UIColor {
            return UIColor(hexString: separatorColor)
        }
    }
    
    public struct TextView: Codable {
        var backgroundColor: String
        var textColor: String
        var borderColor: String
        public var borderWidth: CGFloat
        public var shadowWidth: CGFloat
        public var cornerRadius: CGFloat
        public var fontSize: CGFloat
        public var placeholder: String?
        var placeholderTextColor: String
        var helperTextColor: String
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            backgroundColor = values[.backgroundColor] ?? kDefaultBackgroundColor
            textColor = values[.textColor] ?? kDefaultTextColor
            borderColor = values[.borderColor] ?? kDefaultBorderColor
            borderWidth = values[.borderWidth] ?? kDefaultBorderWidth
            shadowWidth = values[.shadowWidth] ?? kDefaultShadowWidth
            cornerRadius = values[.cornerRadius] ?? kDefaultCornerRadius
            fontSize = values[.fontSize] ?? kDefaultFontSize
            placeholder = values[.placeholder]
            placeholderTextColor = values[.placeholderTextColor] ?? kDefaultPlaceholderTextColor
            helperTextColor = values[.helperTextColor] ?? kDefaultHelperTextColor
        }
        
        public func getTextColor() -> UIColor {
            return UIColor(hexString: textColor)
        }
        
        public func getBackgroundColor() -> UIColor {
            return UIColor(hexString: backgroundColor)
        }
        
        public func getBorderColor() -> UIColor {
            return UIColor(hexString: borderColor)
        }
        
        public func getPlaceHolderTextColor() -> UIColor {
            return UIColor(hexString: placeholderTextColor)
        }
        
        public func getHelperTextColor() -> UIColor {
            return UIColor(hexString: helperTextColor)
        }
    }
    
    public struct Bubble: Codable {
        var backgroundColor: String
        var textColor: String
        var selectedTextColor: String
        var borderColor: String
        public var borderWidth: CGFloat
        public var shadowWidth: CGFloat
        public var cornerRadius: CGFloat
        public var fontSize: CGFloat
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            backgroundColor = values[.backgroundColor] ?? kDefaultBackgroundColor
            textColor = values[.textColor] ?? kDefaultTextColor
            borderColor = values[.borderColor] ?? kDefaultBorderColor
            borderWidth = values[.borderWidth] ?? kDefaultBorderWidth
            shadowWidth = values[.shadowWidth] ?? kDefaultShadowWidth
            cornerRadius = values[.cornerRadius] ?? kDefaultCornerRadius
            fontSize = values[.fontSize] ?? kDefaultFontSize
            selectedTextColor = values[.selectedTextColor] ?? kDefaultSelectedTextColor
        }
        
        public func getTextColor() -> UIColor {
            return UIColor(hexString: textColor)
        }
        
        public func getBackgroundColor() -> UIColor {
            return UIColor(hexString: backgroundColor)
        }
        
        public func getBorderColor() -> UIColor {
            return UIColor(hexString: borderColor)
        }
        
        public func getSelectedTextColor() -> UIColor {
            return UIColor(hexString: selectedTextColor)
        }
    }
    
    public struct Ticker: Codable {
        public var borderWidth: CGFloat
        public var shadowWidth: CGFloat
        public var cornerRadius: CGFloat
        public var fontSize: CGFloat
        public var imagePosition: Int = 0
        
        public struct TickerTypes: Codable {
            var tickerType: Int?
            private var backgroundColor: String
            private var borderColor: String
            private var textColor: String
            
            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                tickerType = values[.tickerType] ?? 0
                backgroundColor = values[.backgroundColor] ?? kDefaultBackgroundColor
                borderColor = values[.borderColor] ?? kDefaultBorderColor
                textColor = values[.textColor] ?? kDefaultTextColor
            }
            
            public func getBackgroundColor() -> UIColor {
                return UIColor(hexString: backgroundColor)
            }
            
            public func getBorderColor() -> UIColor {
                return UIColor(hexString: borderColor)
            }
            
            public func getTextColor() -> UIColor {
                return UIColor(hexString: textColor)
            }
        }
        
        public var types: [TickerTypes]?
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            borderWidth = values[.borderWidth] ?? kDefaultBorderWidth
            shadowWidth = values[.shadowWidth] ?? kDefaultShadowWidth
            cornerRadius = values[.cornerRadius] ?? kDefaultCornerRadius
            fontSize = values[.fontSize] ?? kDefaultFontSize
            types = values[.types]
        }
    }
    
    public struct MultiSelect: Codable {
        var backgroundColor: String
        var textColor: String
        var selectedTextColor: String
        var imageTineColor: String
        var selectedImageTintColor: String
        var borderColor: String
        public var borderWidth: CGFloat
        public var shadowWidth: CGFloat
        public var cornerRadius: CGFloat
        public var fontSize: CGFloat
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            backgroundColor = values[.backgroundColor] ?? kDefaultBackgroundColor
            textColor = values[.textColor] ?? kDefaultTextColor
            borderColor = values[.borderColor] ?? kDefaultBorderColor
            borderWidth = values[.borderWidth] ?? kDefaultBorderWidth
            shadowWidth = values[.shadowWidth] ?? kDefaultShadowWidth
            cornerRadius = values[.cornerRadius] ?? kDefaultCornerRadius
            fontSize = values[.fontSize] ?? kDefaultFontSize
            selectedTextColor = values[.selectedTextColor] ?? kDefaultSelectedTextColor
            imageTineColor = values[.imageTineColor] ?? kDefaultTextColor
            selectedImageTintColor = values[.selectedImageTintColor] ?? kDefaultSelectedTextColor
        }
        
        public func getTextColor() -> UIColor {
            return UIColor(hexString: textColor, alpha: 0.6)
        }
        
        public func getImageTintColor() -> UIColor {
            return UIColor(hexString: imageTineColor)
        }
        
        public func getBackgroundColor() -> UIColor {
            return UIColor(hexString: backgroundColor)
        }
        
        public func getBorderColor() -> UIColor {
            return UIColor(hexString: borderColor)
        }
        
        public func getSelectedTextColor() -> UIColor {
            return UIColor(hexString: selectedTextColor, alpha: 0.6)
        }
        
        public func getSelectedImageTintColor() -> UIColor {
            return UIColor(hexString: selectedImageTintColor)
        }
    }
    
    public struct Alert: Codable {
        var backgroundColor: String
        var textColor: String
        var borderColor: String
        public var borderWidth: CGFloat
        public var shadowWidth: CGFloat
        public var cornerRadius: CGFloat
        public var fontSize: CGFloat
        
        public struct Status: Codable {
            var type: AlertType?
            var statusColor: String
            var statusImage: String?
            var imageTint: String?
            
            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                type = values[.type] ?? .info
                statusColor = values[.statusColor] ?? kDefaultStatusColor
                statusImage = values[.statusImage]
                imageTint = values[.imageTint]
            }
            
            public func getStatusColor() -> UIColor {
                return UIColor(hexString: statusColor)
            }
            
            public func getImageTintColor() -> UIColor? {
                if let imageTint = imageTint {
                    return UIColor(hexString: imageTint)
                }
                return nil
            }
        }
        
        public var status: [Status]?
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            backgroundColor = values[.backgroundColor] ?? kDefaultBackgroundColor
            textColor = values[.textColor] ?? kDefaultTextColor
            borderColor = values[.borderColor] ?? kDefaultBorderColor
            borderWidth = values[.borderWidth] ?? kDefaultBorderWidth
            shadowWidth = values[.shadowWidth] ?? kDefaultShadowWidth
            cornerRadius = values[.cornerRadius] ?? kDefaultCornerRadius
            fontSize = values[.fontSize] ?? kDefaultFontSize
            status = values[.status]
        }
        
        public func getTextColor() -> UIColor {
            return UIColor(hexString: textColor)
        }
        
        public func getBackgroundColor() -> UIColor {
            return UIColor(hexString: backgroundColor)
        }
        
        public func getBorderColor() -> UIColor {
            return UIColor(hexString: borderColor)
        }
    }
    
    public let Button: Button?
    public let TextField: TextField?
    public let TextView: TextView?
    public let Bubble: Bubble?
    public let Ticker: Ticker?
    public let MultiSelect: MultiSelect?
    public let Alert: Alert?
}
