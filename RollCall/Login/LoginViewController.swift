//
//  LoginViewController.swift
//  BaseProject
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var tcKNTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func isNavigationBarHidden() -> Bool {
        return true
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let viewController = ClassesViewController()
        pushViewController(viewController: viewController)
    }
}
