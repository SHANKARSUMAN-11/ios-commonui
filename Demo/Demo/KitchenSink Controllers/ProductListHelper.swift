//
//  ProductListHelper.swift
//  Demo
//
//  Created by Ashok Kumar on 24/05/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class ProductListHelper: NSObject, CommonTableViewDataSource, CommonTableViewDelegate {
    
    var controller: CommonTableViewController?
    
    func backgroundColorForTableView() -> UIColor? {
        return UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    }
    
    func shouldShowSeparatorLine() -> Bool {
        return false
    }
    
    func reusableIdentifiers() -> [String]? {
        return ["VerticalProductCell"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VerticalProductCell", for: indexPath) as? BaseTableViewCell,
            let customView = cell.customView as? VerticalProductCell else {
                return UITableViewCell()
        }
        
        // create an NSMutableAttributedString that we'll append everything to
        
        
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "cnc")

        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

        let fullString = NSMutableAttributedString(attributedString: image1String)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(NSAttributedString(string: " NIKE Men Air Presto Mid Acrony…"))
//
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
//        customView.defaultStateColor = .red
//        customView.state = .plain
//        let attrString: NSMutableAttributedString? = nil
//        customView.headerPlaceholderText = attrString
//        customView.helperText = attrString
//        customView.textFieldText = attrString
//        customView.headerPlaceholderText = NSAttributedString(string: "PlaceHolder\(indexPath.row)")
//        if indexPath.row > 5 {
//            customView.textFieldText = NSAttributedString(string: "Textfield\(indexPath.row)")
//        }
        customView.productImage.image = UIImage(named: "productCellSample1")
        customView.productName?.attributedText = fullString
        customView.setPrice(withPrice: "Rp2.499.999", strikeThroughPriceDisplay: "Rp4.899.000", isCNC: false, discount: 14)
        customView.view.layer.cornerRadius = 8
        if indexPath.row % 2 == 0 {
            customView.setRating(averageRating: 4, reviewCount: 10)
        }
        //customView.shouldShowBuyButton = true
        //customView.setProductStatus(with: .trending)
        customView.setMerchant(minSyncProductPrice: "12000", count: 62, linkable: true)
        customView.setWishlistStatus(with: true)
        //customView.setPromoImage(with: "favorite")

        customView.productStatusLabel2.text = "NEW".uppercased()
        customView.setProductStatus(with: .withoutGradient, colorRange: [.green])
        customView.productStatusLabel2.roundedCorners(corners: [.topLeft, .topRight, .bottomRight, .bottomLeft], radius: 9.0)
        
        customView.variantsView.setVariants(withColors: [UIColor(hexString: "#b8e986"), UIColor(hexString: "#cc91ff"), UIColor(hexString: "#dc662d"), UIColor(hexString: "#72706f")])
        
        let width = cell.frame.width
        
        cell.setCard(leading: 16.0, trailing: (width * 2 / 3) - 16, bottom: 16.0, top: 16.0, contentViewBackgroundColor: .clear)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    

    public func showProductList(withHelper helper: ProductListHelper) {
        //DispatchQueue.main.async {
            let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
            helper.controller = controller
            //helper.completionHandler = completionHandler
            UIApplication.topMost?.show(controller, sender: self)
            //present(controller, animated: true, completion: nil)
        //}
    }
}
