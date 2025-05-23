import SwiftUI

struct MainTabView: View {
    @AppStorage("colorScheme") private var colorScheme: String = "dark"

    var body: some View {
        TabView {
            MatchesView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text(NSLocalizedString("Matches", comment: "Onglet pour les matchs"))
                }

            LiveMatchesView()
                .tabItem {
                    Image(systemName: "bolt.fill")
                    Text(NSLocalizedString("Live", comment: "Onglet pour les matchs en direct"))
                }

            ScoresView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text(NSLocalizedString("Scores", comment: "Onglet pour les scores"))
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text(NSLocalizedString("Settings", comment: "Onglet des paramètres"))
                }
        }
        .accentColor(Color(hex: "#9B5DE5"))
        .preferredColorScheme(
            colorScheme == "light" ? .light :
            colorScheme == "dark" ? .dark :
            nil
        )
    }
}


