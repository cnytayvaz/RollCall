//
//  BaseViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLocalization),
                                               name: NSNotification.Name(LocalizationManager.LanguageChangeNotificationKey),
                                               object: nil)
        setText()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LocalizationManager.LanguageChangeNotificationKey), object: nil)
    }
    
    @objc fileprivate func updateLocalization() {
        setText()
    }
    
    func setText() {
        
    }
}


