//
//  CustomCardViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 12/06/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomCardViewController: UIViewController {

    @IBOutlet weak var customButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customButton.setButton(withTitle: "Show Card", titleColor: nil, image: nil, type: .contained)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @IBAction func didTapButton(_ sender: CustomButton) {
        let customCardHelper = CustomCardHelper()
        customCardHelper.showCard(withHelper: customCardHelper)
    }

}
