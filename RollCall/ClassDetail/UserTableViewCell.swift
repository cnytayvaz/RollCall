//
//  UserTableViewCell.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

protocol UserTableViewCellDelegate {
    func userRollCallButtonTapped(user: User)
}

class UserTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var userNoLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRollCallButton: UIButton!
    
    var user: User?
    var delegate: UserTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userRollCallButton.layer.borderWidth = 0.3
        userRollCallButton.layer.borderColor = UIColor.blue.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with user: User, delegate: UserTableViewCellDelegate) {
        self.user = user
        self.delegate = delegate
        userNoLabel.text = user.no
        userNameLabel.text = user.name
    }
    
    @IBAction func userRollCallButtonTapped(_ sender: Any) {
        guard let user = user else { return }
        delegate?.userRollCallButtonTapped(user: user)
    }
    
}
