//
//  ChangePasswordViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 8.10.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    
    enum PageMode {
        case firstChange
        case optionalChange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with pageMode: PageMode = .optionalChange) {
        self.pageMode = pageMode
        super.init(nibName: nil, bundle: nil)
    }
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordAgainTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    var pageMode = PageMode.optionalChange

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if pageMode == .firstChange {
            currentPasswordTextField.isHidden = true
        }
    }

    override func setText() {
        currentPasswordTextField.placeholder = "Şimdiki Şifre".localized()
        newPasswordTextField.placeholder = "Yeni Şifre".localized()
        newPasswordAgainTextField.placeholder = "Yeni Şifre(Tekrar)".localized()
        okButton.setTitle("Tamam".localized(), for: .normal)
    }

}
