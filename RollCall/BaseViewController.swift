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
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background.png"))
        definesPresentationContext = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLocalization),
                                               name: NSNotification.Name(LocalizationManager.LanguageChangeNotificationKey),
                                               object: nil)
        setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = isNavigationBarHidden()
        navigationItem.hidesBackButton = !isBackActionEnabled()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isBackActionEnabled()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LocalizationManager.LanguageChangeNotificationKey), object: nil)
    }
    
    @objc fileprivate func updateLocalization() {
        setText()
    }
    
    func setText() {
        
    }
    
    func isNavigationBarHidden() -> Bool {
        return false
    }
    
    func isBackActionEnabled() -> Bool {
        return true
    }
}


