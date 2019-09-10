//
//  LocalizationManager.swift
//  BaseProject
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import Foundation

class LocalizationManager {
    
    static let LanguageChangeNotificationKey = "LanguageChangeNotification"
    fileprivate static let DefaultLanguage = "en"
    fileprivate static let CurrentLanguageKey = "CurrentLanguageKey"
    
    static func availableLanguages(_ includeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.firstIndex(of: "Base"), !includeBase {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    static func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LocalizationManager.CurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    static func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LocalizationManager.CurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LocalizationManager.LanguageChangeNotificationKey), object: nil)
        }
    }
    
    static func defaultLanguage() -> String {
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LocalizationManager.DefaultLanguage
        }
        
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            return preferredLanguage
        }
        
        return LocalizationManager.DefaultLanguage
    }
    
    static func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    static func displayNameForLanguageIdentifier(_ languageIdentifier: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: languageIdentifier) {
            return displayName
        }
        
        return String()
    }
    
    static func LanguageIdentifierForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        let availableLanguages: [String] = self.availableLanguages()
        
        for languageIdentifier in availableLanguages {
            if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: languageIdentifier), displayName == language {
                return languageIdentifier
            }
        }
        
        return String()
    }
}
