import SwiftUI

struct FavoritesView: View {
    var body: some View {
        ZStack {
            Color(hex: "#1f1f1f").edgesIgnoringSafeArea(.all)
            Text("Vos matchs favoris s'afficheront ici.")
                .foregroundColor(.white)
                .padding()
        }
    }
}
