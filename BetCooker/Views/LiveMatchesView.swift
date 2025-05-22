import SwiftUI

struct LiveMatchesView: View {
    var body: some View {
        ZStack {
            Color(hex: "#121212").edgesIgnoringSafeArea(.all)
            Text("Aucun match en direct pour l’instant.")
                .foregroundColor(.white)
                .padding()
        }
    }
}
