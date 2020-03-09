//
//  CustomPagerViewController.swift
//  Demo
//
//  Created by RONAK GARG on 30/05/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import CommonUIKit

class CustomPagerViewController: NSObject, PagerViewConfigurationProtocol, PagerViewHelperDelegate {
    
    weak var controller: CommonTableViewController?
    fileprivate let imageNames = ["1.jpg"]
    fileprivate let imageNames2 = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg"]

    var helper: PagerViewHelper?
    var pageController: CommonCollectionViewController?
    
    func getPageControlConfig() -> PageControlConfig {
        let config = PageControlConfig()
//        config.shouldShowPageControl = false
        config.style = .ellipse
        return config
    }
    
    func getPagerViewConfig() -> PagerViewConfig {
        let config = PagerViewConfig()
        config.automaticSlidingInterval = 0
        config.decelerationDistance = 1
        config.itemSize = CGSize(width: 200, height: ((9/16)*UIScreen.main.bounds.width))
        config.interitemSpacing = 8.0
        config.removesInfiniteLoopForSingleItem = true
        config.isInfiniteScrolling = false
        config.scrollDirection = .horizontal
        config.horizontalInset = 5.0
        config.verticalInset = 8.0
        config.leadingSpace = 0
        return config
    }
    func didTapPageName() {
        
    }
}

extension CustomPagerViewController: CommonTableViewDelegate {
    func shouldShowSeparatorLine() -> Bool {
        return false
    }
    
}
extension CustomPagerViewController: CommonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((9/16)*UIScreen.main.bounds.width)
    }
    
    func reusableIdentifiersForSimpleTableViewCell() -> [String]? {
        return ["test"]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)
        if cell.contentView.subviews.count == 0 {
            helper = PagerViewHelper(withPagerConfigDelegate: self)
//            helper?.isPagingEnabled = false
            helper?.delegate = self
//            helper?.shouldShowPageName = false
            if UIDevice.current.userInterfaceIdiom == .pad {
                helper?.pageNameFont = UIFont(name: "EffraMedium-Regular", size: 18.0)
            } else {
                helper?.pageNameFont = UIFont(name: "EffraMedium-Regular", size: 12.0)
            }
            pageController = CommonCollectionViewController(dataSource: helper, delegate: helper)
            
            helper?.vc = pageController
            let fiveZs = Array(repeating: "Lihat Semua Promo", count: self.imageNames.count)
            helper?.setData(data: imageNames, labelData: [])
            helper?.setHandler(reusableIdentifier: "UIImageView", dataHandler: { (collectionView, indexPath, customView, data) in
                if let customView = customView as? UIImageView, let product = data as? String {
                    customView.image = UIImage(named: product)
                    customView.layer.cornerRadius = 10
                    customView.clipsToBounds = true
                }
            }, delegateHandler: { (collectionView, indexPath, data) in
                
            })
            if let customView = pageController?.view {
                cell.contentView.addSubview(customView)
                customView.anchor(top: cell.contentView.topAnchor, left: cell.contentView.leftAnchor, bottom: cell.contentView.bottomAnchor, right: cell.contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            }
        } else {
            helper?.reloadData(with: imageNames2)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func backgroundColorForTableView() -> UIColor? {
        return UIColor.groupTableViewBackground
    }
    
}
