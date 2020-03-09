//
//  BarcodeGenerator.swift
//  CommonUIKit
//
//  Created by Prince Mathew on 27/02/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import Foundation

public extension Data {
    
    /// Bar code generator from Data
    ///
    /// - Parameters:
    ///   - shouldInvertColor: invert colors
    ///   - customColor: custom color for QR
    /// - Returns: Generated QR Image
    public func generateBarcode(shouldInvertColor: Bool = false, customColor: UIColor? = nil) -> UIImage? {
        return self.getBarcode(shouldInvertColor: shouldInvertColor, customColor: customColor)
    }
    
    internal func getBarcode(shouldInvertColor: Bool, customColor: UIColor?) -> UIImage? {
        
        guard let qrFilter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        qrFilter.setValue(self, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else {
            return nil
        }
        
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        var scaledQrImage = qrImage.transformed(by: transform)
        
        if shouldInvertColor,
            let invertedImage = scaledQrImage.inverted {
            scaledQrImage = invertedImage
        }
        
        if let color = customColor,
            let coloredImage = scaledQrImage.changeColor(using: color) {
            scaledQrImage = coloredImage
        }
        
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else{
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
