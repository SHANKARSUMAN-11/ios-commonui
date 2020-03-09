//
//  QRGenerator.swift
//  CommonUIKit
//
//  Created by Prince Mathew on 22/02/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import Foundation

public extension Data {

    /// QR code generator from Data
    ///
    /// - Parameters:
    ///   - shouldInvertColor: invert colors
    ///   - customColor: custom color for QR
    ///   - logo: logo to be presented in center
    /// - Returns: Generated QR Image
    public func generateQR(shouldInvertColor: Bool = false, customColor: UIColor? = nil, logo: UIImage? = nil) -> UIImage? {
        return self.getQR(shouldInvertColor: shouldInvertColor, customColor: customColor, logo: logo)
    }
    
    internal func getQR(shouldInvertColor: Bool, customColor: UIColor?, logo: UIImage?) -> UIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
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
        
        if let logoImage = logo,
            let qrWithLogo = scaledQrImage.addLogo(with: logoImage) {
            scaledQrImage = qrWithLogo
        }
        
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else{
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

extension CIImage {
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var invertedTransparent: CIImage? {
        return inverted?.blackTransparent
    }
    
    /// Inverts the colors.
    var inverted: CIImage? {
        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil }
        
        colorInvertFilter.setValue(self, forKey: kCIInputImageKey)
        return colorInvertFilter.outputImage
    }
    
    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        
        maskToAlphaFilter.setValue(self, forKey: kCIInputImageKey)
        return maskToAlphaFilter.outputImage
    }
    
    /// Applies the given color as a tint color.
    func changeColor(using color: UIColor) -> CIImage? {
        guard
            let transparentImage = invertedTransparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentImage, forKey: kCIInputBackgroundImageKey)
        return filter.outputImage
    }
    
    /// Add logo
    func addLogo(with image: UIImage) -> CIImage? {
        guard let logoImage = image.cgImage else { return nil }
        let logoCiImage = CIImage(cgImage: logoImage)
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let width = (extent.size.width * 10) / image.size.width
        let height = (extent.size.height * 10) / image.size.height
        let logoImageWidth = (image.size.width * width ) / 100
        let logoImageHeight = (image.size.height * height ) / 100
        var set = CGAffineTransform(scaleX: width / 100, y: height / 100)
        set.tx = self.extent.midX - (logoImageWidth)
        set.ty = self.extent.midY - (logoImageHeight)
        combinedFilter.setValue(logoCiImage.transformed(by: set), forKey: kCIInputImageKey)
        combinedFilter.setValue(self, forKey: kCIInputBackgroundImageKey)
        return combinedFilter.outputImage
    }
}
