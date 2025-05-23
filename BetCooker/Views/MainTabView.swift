import SwiftUI

struct MainTabView: View {
    @AppStorage("colorScheme") private var colorScheme: String = "dark"

    var body: some View {
        TabView {
            MatchesView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Matchs")
                }

            LiveMatchesView()
                .tabItem {
                    Image(systemName: "bolt.fill")
                    Text("Live")
                }

            ScoresView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Scores")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
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
