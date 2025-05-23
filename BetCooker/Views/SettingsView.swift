import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @AppStorage("colorScheme") private var colorScheme: String = "dark"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Language", comment: ""))) {
                    Picker(NSLocalizedString("App Language", comment: ""), selection: $languageManager.selectedLanguage) {
                        Text("🇬🇧 English").tag("en")
                        Text("🇫🇷 Français").tag("fr")
                        Text("🇪🇸 Español").tag("es")
                        Text("🇩🇪 Deutsch").tag("de")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle(NSLocalizedString("Settings", comment: ""))
        }
        .preferredColorScheme(
            colorScheme == "light" ? .light :
            colorScheme == "dark" ? .dark :
            nil
        )
    }
}



