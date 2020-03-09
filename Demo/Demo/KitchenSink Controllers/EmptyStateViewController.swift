//
//  EmptyStateViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 07/05/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class EmptyStateViewController: UIViewController, CustomButtonDelegate {

    @IBOutlet weak var emptyCartButton: CustomButton!
    @IBOutlet weak var noInternetButton: CustomButton!
    @IBOutlet weak var noSearchButton: CustomButton!
    @IBOutlet weak var customButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
    }
    
    func setupButtons() {
        
        emptyCartButton.setButton(withTitle: "Empty Cart", image: nil, type: .contained)
        emptyCartButton.tag = 0
        noInternetButton.setButton(withTitle: "No Internet", image: nil, type: .contained)
        noInternetButton.tag = 1
        noSearchButton.setButton(withTitle: "No Search Results", image: nil, type: .contained)
        noSearchButton.tag = 2
        customButton.setButton(withTitle: "Custom", image: nil, type: .contained)
        customButton.tag = 4
        
        emptyCartButton.delegate = self
        noInternetButton.delegate = self
        noSearchButton.delegate = self
        customButton.delegate = self
    }
    
    func didTapButton(sender: Any) {
        
        if let button = sender as? CustomButton {
//            performSegue(withIdentifier: "showEmptyState", sender: button.tag)
            
            if button.tag == 0 {
                self.view.showEmptyState(withTitle: NSAttributedString(string: "Lho, Kok Sepi?"), description: NSAttributedString(string: "Mau diisi apa ya Bag sebesar ini? Coba masukkan produk yang sudah kebawa mimpi. Habis belanja bisa dapat poin Blibli Rewards lagi!"), image: UIImage(named: "empty_cart"), buttonTitle: NSAttributedString(string: "Cari Produk"), completion: { view in
                    view.removeFromSuperview()
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? EmptyStateDetailViewController, let tag = sender as? Int {
            vc.type = tag
        }
    }

}

