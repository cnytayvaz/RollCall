//
//  SuccessfulViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 11.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit
import Lottie

class SuccessfulViewController: BaseViewController {
    
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageLabel.isHidden = true
        animationView.animation = Animation.named("check-animation")
        animationView.play()
    }
    
    override func isNavigationBarHidden() -> Bool {
        return true
    }
    
    override func isBackActionEnabled() -> Bool {
        return false
    }
    
    override func setText() {
        messageTitleLabel.text = "İşlem Başarılı".localized()
        messageLabel.text = "".localized()
        confirmButton.setTitle("Tamam".localized(), for: .normal)
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        popToRootViewController()
    }
}
