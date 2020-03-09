//
//  Extensions.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 22/03/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit



public extension UIColor {
    public convenience init(hexString: String?, alpha: CGFloat = 1.0) {
        
        //TODO: Check this
        guard let hex_String = hexString else { self.init(red:0.0, green:0.0, blue:0.0, alpha:0); return }
        
        let hexString: String = hex_String.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        
        if hexColor.count == 8 {
            let r, g, b, a: CGFloat
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                
            } else {
                self.init(red:0.0, green:0.0, blue:0.0, alpha:0); return
            }
            
        } else {
            var color: UInt32 = 0
            scanner.scanHexInt32(&color)
            let mask = 0x000000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            let red   = CGFloat(r) / 255.0
            let green = CGFloat(g) / 255.0
            let blue  = CGFloat(b) / 255.0
            self.init(red:red, green:green, blue:blue, alpha:alpha)
        }
    }
}

public extension UIImage {
    
    func getImage(named name: String?) -> UIImage? {
    
        if let name = name {
            return UIImage(named: name, in: Bundle.main, compatibleWith: nil) ?? UIImage(named: name, in: Bundle(for: CustomTicker.self), compatibleWith: nil)
        }
        return nil
    }
}
