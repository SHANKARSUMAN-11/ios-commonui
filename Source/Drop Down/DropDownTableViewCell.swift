//
//  DropDownTableViewCell.swift
//  CommonUIKit
//
//  Created by Ashok Kumar on 10/04/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import UIKit

public protocol DropDownTableViewCellDelegate: class {
    func didTapRightButton(sender: Any, isSelected: Bool)
}

public extension DropDownTableViewCellDelegate {
    func didTapRightButton(sender: Any, isSelected: Bool) {}
}

public class DropDownTableViewCell: UITableViewCell {

    @IBOutlet public weak var backgroundView_: UIView!
    //@IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet public weak var customSelect: CustomSelect!
    
    public weak var delegate: DropDownTableViewCellDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundView_.layer.cornerRadius = 8.0
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /*
    public func setRightButton(title: String?, tintColor: UIColor?, image: UIImage?, selectedImage: UIImage?, isSelected: Bool) {
        
        _image = image
        _selectedImage = selectedImage
        
        setButtonImage(isSelected: isSelected)
        
        rightButton.tintColor = tintColor
    }
    
    func setButtonImage(isSelected: Bool) {
        
        if isSelected {
            rightButton.setImage(_selectedImage, for: .normal)
        } else {
            rightButton.setImage(_image, for: .normal)
        }
    }
    */
    
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        delegate?.didTapRightButton(sender: self, isSelected: self.isSelected)
    }
    
}
