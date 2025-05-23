//
//  SettingView.swift
//  BetCooker
//
//  Created by Guest User on 23/05/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    @AppStorage("colorScheme") private var colorScheme: String = "dark"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Language")) {
                    Picker("App Language", selection: $selectedLanguage) {
                        Text("English").tag("en")
                        Text("Français").tag("fr")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Theme")) {
                    Picker("App Theme", selection: $colorScheme) {
                        Text("Dark").tag("dark")
                        Text("Light").tag("light")
                        Text("System").tag("system")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Settings")
        }
        .preferredColorScheme(
            colorScheme == "light" ? .light :
            colorScheme == "dark" ? .dark :
            nil
        )
    }
}
