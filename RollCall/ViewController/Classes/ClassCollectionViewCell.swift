//
//  ClassCollectionViewCell.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class ClassCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 0.3
    }
    
    func configure(with classroom: Classroom) {
        nameLabel.text = classroom.name
        selectedView.isHidden = !classroom.selected
    }

}
