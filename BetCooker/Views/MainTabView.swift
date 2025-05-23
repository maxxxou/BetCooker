import SwiftUI

struct MainTabView: View {
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
        }
        .accentColor(Color(hex: "#9B5DE5"))
        .background(.ultraThinMaterial)
    }
}
