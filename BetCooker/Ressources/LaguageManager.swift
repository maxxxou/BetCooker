//
//  LaguageManager.swift
//  BetCooker
//
//  Created by Anatole Babin on 23/05/2025.
//

import SwiftUI

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            // Cette ligne va forcer un redémarrage visuel de l'app
            exit(0)
        }
    }

    init() {
        let preferred = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
        self.selectedLanguage = preferred
    }
}
