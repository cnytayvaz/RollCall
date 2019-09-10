//
//  StringExtension.swift
//  BaseProject
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import Foundation

protocol Localizable {
    func localized() -> String
}

extension String: Localizable {
    
    func localized() -> String {
        let lang = LocalizationManager.currentLanguage()
        
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj") else { return self }
        guard let bundle = Bundle(path: path) else { return self }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
