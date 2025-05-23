import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    @AppStorage("colorScheme") private var colorScheme: String = "dark"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Language", comment: "Section header for language selection"))) {
                    Picker(NSLocalizedString("App Language", comment: "Picker label for language selection"), selection: $selectedLanguage) {
                        Text("English").tag("en")
                        Text("Français").tag("fr")
                        // Tu peux ajouter d'autres langues ici si besoin
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


