//
//  ProductCollectionView.swift
//  Demo
//
//  Created by Ashok Kumar on 07/08/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class ProductCollectionView: NSObject, CommonCollectionViewDelegate, CommonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var controller: CommonCollectionViewController?
    
    public func showProductList(withHelper helper: ProductCollectionView) {
        let controller = CommonCollectionViewController.init(dataSource: helper, delegate: helper)
        helper.controller = controller
        UIApplication.topMost?.show(controller, sender: self)
    }
    
    func reusableIdentifiers() -> [String]? {
        return ["VerticalProductCell"]
    }
    
    func shouldLoadCollectionView(collectionView: UICollectionView, forController: CommonCollectionViewController) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = (collectionView.bounds.width - 1)/2
        if UIDevice.current.userInterfaceIdiom == .pad {
            width = (collectionView.bounds.width - 2)/3
        }
        return CGSize(width: width, height: width + 145.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = BaseCollectionViewCell.dequeueReusableCell(for: collectionView, with: "VerticalProductCell", indexPath: indexPath) as? BaseCollectionViewCell,
            let customView = cell.customView as? VerticalProductCell else {
                return UICollectionViewCell()
        }
        
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "cnc")
        
        let image1String = NSAttributedString(attachment: image1Attachment)
        let fullString = NSMutableAttributedString(attributedString: image1String)
        fullString.append(NSAttributedString(string: " NIKE Men Air Presto Mid Acrony…"))
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        customView.productImage.image = UIImage(named: "productCellSample1")
        customView.productName?.attributedText = fullString
        customView.setPrice(withPrice: "Rp2.499.999", strikeThroughPriceDisplay: "Rp4.899.000", isCNC: false, discount: 14)
        customView.view.layer.cornerRadius = 8
        if indexPath.row % 2 == 0 {
            customView.setRating(averageRating: 4, reviewCount: 10)
        }
        //customView.shouldShowBuyButton = true
//        customView.setProductStatus(with: .trending)
        customView.setMerchant(minSyncProductPrice: "12000", count: 62, linkable: true)
        customView.setWishlistStatus(with: true)
        customView.setPromoImage(with: UIImage(named: "DLS-ZeroPercent"))
        customView.setProductStatus(with: .withGradient, text: NSAttributedString(string: "Trending"), colorRange: [.green, .red])
        
//        customView.productStatusLabel2.text = "NEW".uppercased()
//        customView.setProductStatus(with: .comingSoon, colorRange: [.green])
//        customView.productStatusLabel2.roundedCorners(corners: [.topLeft, .topRight, .bottomRight, .bottomLeft], radius: 9.0)
        
        customView.variantsView.setVariants(withColors: [UIColor(hexString: "#b8e986"), UIColor(hexString: "#cc91ff"), UIColor(hexString: "#dc662d"), UIColor(hexString: "#72706f")])
        
        let width = cell.frame.width
        
        cell.setCard(leading: 16.0, trailing: (width * 2 / 3) - 16, bottom: 16.0, top: 16.0, contentViewBackgroundColor: .clear)
        
        customView.layer.shadowColor = UIColor.black.cgColor
        customView.layer.shadowOpacity = 0.12
        customView.layer.shadowRadius = 5.0
        customView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        customView.anchor(top: cell.topAnchor, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: cell.rightAnchor, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0, height: 0)
        
        return cell
    }
    

    
}
