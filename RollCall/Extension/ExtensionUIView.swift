//
//  ExtensionUIView.swift
//  BaseProject
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

var indicatorMap: [String: UIView] = [:]


extension UIView {
    
    
    public func showIndicator(identifier: String) {
        
        if indicatorMap[identifier] != nil {
            return
        }
        
        let spinnerView = UIView.init(frame: self.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.addSubview(spinnerView)
        }
        indicatorMap[identifier] = spinnerView
    }
    
    public func hideIndicator(identifier: String) {
        DispatchQueue.main.async {
            indicatorMap[identifier]?.removeFromSuperview()
            indicatorMap[identifier] = nil
        }
    }
    
    
}
