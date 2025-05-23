import Foundation
import Combine

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
            Bundle.setLanguage(selectedLanguage)
            objectWillChange.send()
        }
    }

    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Locale.current.languageCode ?? "en"
        Bundle.setLanguage(self.selectedLanguage)
    }
}
