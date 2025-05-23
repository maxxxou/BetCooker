import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    @AppStorage("colorScheme") private var colorScheme: String = "dark"
    @StateObject private var languageManager = LanguageManager()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Language", comment: "Section header for language selection"))) {
                    Picker(NSLocalizedString("App Language", comment: "Picker label for language selection"), selection: $languageManager.selectedLanguage) {
                        Text("🇬🇧 English").tag("en")
                        Text("🇫🇷 Français").tag("fr")
                        Text("🇪🇸 Espanol").tag("es")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text(NSLocalizedString("Theme", comment: "Section header for theme selection"))) {
                    Picker(NSLocalizedString("App Theme", comment: "Picker label for app theme"), selection: $colorScheme) {
                        Text(NSLocalizedString("Dark", comment: "Dark theme option")).tag("dark")
                        Text(NSLocalizedString("Light", comment: "Light theme option")).tag("light")
                        Text(NSLocalizedString("System", comment: "System theme option")).tag("system")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle(NSLocalizedString("Settings", comment: "Settings view title"))
        }
        .preferredColorScheme(
            colorScheme == "light" ? .light :
            colorScheme == "dark" ? .dark :
            nil
        )
    }
}


