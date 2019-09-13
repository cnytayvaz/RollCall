//
//  RegisterSchoolViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 11.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class RegisterSchoolViewController: BaseViewController {

    @IBOutlet weak var schoolNameTextField: UITextField!
    @IBOutlet weak var managerTCKNTextField: UITextField!
    @IBOutlet weak var managerNameTextField: UITextField!
    @IBOutlet weak var managerPhoneNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setText() {
        schoolNameTextField.placeholder = "Okul Adı".localized()
        managerTCKNTextField.placeholder = "Admin TC".localized()
        managerNameTextField.placeholder = "Admin Adı".localized()
        managerPhoneNameTextField.placeholder = "+90 5__ ___ __ __".localized()
        registerButton.setTitle("Register".localized(), for: .normal)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        pushViewController(viewController: SuccessfulViewController())
    }
    
}
