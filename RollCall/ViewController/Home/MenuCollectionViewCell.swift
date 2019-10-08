//
//  MenuCollectionViewCell.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 8.10.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with menuItem: (pageId: Int, description: String, iconName: String, color: UIColor)) {
        imageView.image = UIImage(named: menuItem.iconName)
        titleLabel.text = menuItem.description
        backgroundColor = menuItem.color
    }

}
