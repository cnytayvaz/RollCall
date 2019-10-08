//
//  MessageTableViewCell.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 10.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var readIconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with message: Message) {
        readIconImageView.isHidden = message.read
        senderLabel.text = message.sender
        messageLabel.text = message.message
        timeLabel.text = message.shippingTime
    }
    
}
