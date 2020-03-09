//
//  CustomCardHelper.swift
//  Demo
//
//  Created by Ashok Kumar on 12/06/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomCardHelper: NSObject, CommonTableViewDataSource, CommonTableViewDelegate {
    
    var controller: CommonTableViewController?
    
    func backgroundColorForTableView() -> UIColor? {
        return UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    }
    
    func shouldShowSeparatorLine() -> Bool {
        return false
    }
    
    func reusableIdentifiers() -> [String]? {
        return ["CustomCardView"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCardView", for: indexPath) as? BaseTableViewCell,
            let customView = cell.customView as? CustomCardView else {
                return UITableViewCell()
        }
        
        //customView.bannerImage = UIImage(named: "bannerImage")
        customView.bannerText = NSAttributedString(string: "HSBC")
        customView.bannerHeight = 50.0 //cell.contentView.frame.height
        
        //customView.infoImage = UIImage(named: "infoBanner")
        customView.infoText = NSAttributedString(string: "Special HSBC Discount for BlibliMart Items, Rp50,000 Cashback.")
        //customView.infoHeight = 50.0
        
        customView.logoImage = UIImage(named: "telephone")
        customView.logoWidth = 20.0
        customView.logoImageBorderWidth = 0.5
        customView.logoImageBorderColor = .lightGray
        
        //customView.leftInset = 25.0
        customView.bannerImageView.image = UIImage(named: "bannerImage")
        customView.cornerRadius_ = 8.0
        customView.addShadow(radius: 7.0, shadowOffset: CGSize(width: 0.0, height: 0.0), shadowColor: UIColor.gray, shadowOpacity: 0.7)
        
        cell.setCard(leading: 16.0, trailing: 50.0, bottom: 16.0, top: 16.0, contentViewBackgroundColor: .clear)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    public func showCard(withHelper helper: CustomCardHelper) {
        let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
        helper.controller = controller
        UIApplication.topMost?.show(controller, sender: self)
    }
}
