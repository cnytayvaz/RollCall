//
//  ConfirmCodeViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 11.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class ConfirmCodeViewController: BaseViewController {

    @IBOutlet weak var confirmCodeTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func isNavigationBarHidden() -> Bool {
        return true
    }
    
    override func isBackActionEnabled() -> Bool {
        return false
    }
    
    override func setText() {
        confirmCodeTextField.placeholder = "Confirm Code".localized()
        confirmButton.setTitle("Tamam".localized(), for: .normal)
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let viewController = SuccessfulViewController()
        pushViewController(viewController: viewController)
    }
    
}
