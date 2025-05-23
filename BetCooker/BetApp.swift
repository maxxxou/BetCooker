import SwiftUI

@main
struct BetApp: App {
    @StateObject private var languageManager = LanguageManager()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(languageManager)
                .preferredColorScheme(.dark)
        }
    }
}




