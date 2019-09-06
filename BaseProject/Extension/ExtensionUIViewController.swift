//
//  ExtensionUIViewController.swift
//  BaseProject
//
//  Created by Cüneyt AYVAZ on 5.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String = "Message",
                          message: String,
                          buttonText: String = "OK",
                          buttonAction: @escaping () -> Void = { }) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: buttonText, style: .default) { _ in
            buttonAction()
        }
        alert.addAction(button)
        
        self.presentViewController(viewController: alert)
    }
    
    func presentViewController(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.present(viewController, animated: animated, completion: completion)
    }
    
    func pushViewController(viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
}
