//
//  CustomCellViewController.swift
//  Demo
//
//  Created by Rajadorai DS on 17/06/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import Foundation
import CommonUIKit

internal class CustomCellViewController: UIViewController {
    
    @IBOutlet weak var listWithDescriptionButton: CustomButton!
    @IBOutlet weak var singleLineListButton: CustomButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onSingleLineListButtonTapped(_ sender: Any) {
        let sample = "no_store"
        let model1 = CustomCellModel(withTitle: "Title of the cell 1", listImage: sample, buttonImage: sample, imageVerticalAlignment: .top, buttonVerticalAlignment: .top)
        let model2 = CustomCellModel(withTitle: "Title of the cell 2", listImage: sample, buttonImage: sample,imageVerticalAlignment: .center, buttonVerticalAlignment: .center)
        let model3 = CustomCellModel(withTitle: "Title of the cell 3", listImage: sample, buttonImage: sample,imageVerticalAlignment: .bottom, buttonVerticalAlignment: .bottom)
        let customCellHelper = CustomCellHelper()
        customCellHelper.datasource = [model1,model2,model3]
        customCellHelper.delegate = self
        customCellHelper.showCustomCell(withHelper: customCellHelper)
    }
    
    @IBAction func onListWithDescriptionButtonTapped(_ sender: Any) {
        let sample = "no_store"
        let model1 = CustomCellModel(withTitle: "Title of the cell 1", withDetail: "Cell Description 1",listImage: sample, buttonImage: sample, imageVerticalAlignment: .top, buttonVerticalAlignment: .bottom)
        let model2 = CustomCellModel(withTitle: "Title of the cell 2", withDetail: "Cell Description 2", listImage: sample, buttonImage: sample, imageVerticalAlignment: .center, buttonVerticalAlignment: .center)
        let model3 = CustomCellModel(withTitle: "Title of the cell 3", withDetail: "Cell Description 3",  listImage: sample, buttonImage: sample,imageVerticalAlignment: .bottom, buttonVerticalAlignment: .top)
        let customCellHelper = CustomCellHelper()
        customCellHelper.datasource = [model1, model2, model3]
        customCellHelper.delegate = self
        customCellHelper.showCustomCell(withHelper: customCellHelper)
    }
    
}

extension CustomCellViewController: CustomCellHelperDelegate {
    
    func didTapCustomCell(sender: CustomCellHelper) {
        //Implementation
    }
    
    
}
