//
//  SchoolTableViewCell.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 11.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with school: School) {
        schoolNameLabel.text = school.name
    }
    
}
