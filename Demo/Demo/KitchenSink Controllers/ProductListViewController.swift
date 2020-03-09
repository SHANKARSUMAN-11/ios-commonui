//
//  ProductListViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 23/05/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var customButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customButton.setButton(withTitle: "Show Product Cell", titleColor: .white, image: nil, type: .contained)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }

    @IBAction func didTapButton(_ sender: CustomButton) {
//        let productListHelper = ProductListHelper()
//        productListHelper.showProductList(withHelper: productListHelper)
        
        let productListHelper = ProductCollectionView()
        productListHelper.showProductList(withHelper: productListHelper)
    }
}
