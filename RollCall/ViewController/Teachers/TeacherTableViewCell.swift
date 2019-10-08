//
//  TeacherTableViewCell.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 13.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class TeacherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with user: User) {
        userNameLabel.text = user.name
        selectedView.isHidden = !user.selected
    }
    
}
