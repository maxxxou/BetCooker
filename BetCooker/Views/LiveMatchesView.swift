import SwiftUI

struct LiveMatchesView: View {
    var body: some View {
        ZStack {
            Color(hex: "#1f1f1f").edgesIgnoringSafeArea(.all)
            Text("Aucun match en direct pour l’instant.")
                .foregroundColor(.white)
                .padding()
        }
    }
}
