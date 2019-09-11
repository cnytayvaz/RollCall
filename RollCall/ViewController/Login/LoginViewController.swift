//
//  LoginViewController.swift
//  BaseProject
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var selectSchoolTextField: UITextField!
    @IBOutlet weak var tcKNTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerSchoolButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectSchoolTextFieldTapped))
        selectSchoolTextField.addGestureRecognizer(gesture)
    }
    
    override func isNavigationBarHidden() -> Bool {
        return true
    }
    
    override func setText() {
        registerSchoolButton.setTitle("Okul Ekle".localized(), for: .normal)
        selectSchoolTextField.placeholder = "Okul Seç".localized()
        tcKNTextField.placeholder = "TC Kimlik No".localized()
        passwordTextField.placeholder = "Şifre".localized()
        loginButton.setTitle("Giriş".localized(), for: .normal)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let viewController = HomeViewController()
        pushViewController(viewController: viewController)
    }
    
    @IBAction func registerSchoolButtonTapped(_ sender: Any) {
        let viewController = RegisterSchoolViewController()
        pushViewController(viewController: viewController)
    }
    
    @objc func selectSchoolTextFieldTapped() {
        let viewController = SelectSchoolViewController()
        viewController.delegate = self
        presentViewController(viewController: viewController)
    }
}

extension LoginViewController: SelectSchoolDelegate {
    
    func didSelect(school: School) {
        selectSchoolTextField.text = school.name
    }
}
