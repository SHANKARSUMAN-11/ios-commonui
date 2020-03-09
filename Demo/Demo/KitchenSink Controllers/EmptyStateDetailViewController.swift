//
//  EmptyStateDetailViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 07/05/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class EmptyStateDetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: EmptyStateBackgroundView!
    
    var type: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case 0:
            backgroundView.image = UIImage(named: "empty_cart")
            backgroundView.title = NSAttributedString(string: "Lho, Kok Sepi?")
            backgroundView.message = NSAttributedString(string: "Mau diisi apa ya Bag sebesar ini? Coba masukkan produk yang sudah kebawa mimpi. Habis belanja bisa dapat poin Blibli Rewards lagi!")
            backgroundView.buttonTitle = NSAttributedString(string: "Cari Produk")
        case 1:
            backgroundView.image = UIImage(named: "no_internet")
            backgroundView.title = NSAttributedString(string: "Yah, Putus!")
            backgroundView.message = NSAttributedString(string: "kalo misal jadi could be unpredictable sometimes gimana? soalnya kalo is unpredictable kesannya kaya selalu unpredictable gitu ga ya? jadi kek gini maksud i:")
            backgroundView.buttonTitle = NSAttributedString(string: "Coba Lagi")
        case 2:
            backgroundView.image = UIImage(named: "no_search")
            backgroundView.title = NSAttributedString(string: "Gak Ketemu Nih...")
            backgroundView.message = NSAttributedString(string: "Setiap pencarian kadang butuh perjuangan. Jangan menyerah, cek kata pencarian lain")
            backgroundView.buttonTitle = NSAttributedString(string: "Yuk, Cari Lagi!")
        case 3:
            backgroundView.image = nil
            backgroundView.title = NSAttributedString(string: "Gak Ketemu Nih...")
            backgroundView.message = NSAttributedString(string: "Setiap pencarian kadang butuh perjuangan. Jangan menyerah, cek kata pencarian lain")
            //backgroundView.buttonTitle = "Yuk, Cari Lagi!"
        default:
            backgroundView.title = nil
            backgroundView.message = nil
            backgroundView.buttonTitle = nil
        }
    }
}
