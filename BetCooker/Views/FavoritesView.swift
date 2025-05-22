import SwiftUI

struct FavoritesView: View {
    var body: some View {
        ZStack {
            Color(hex: "#121212").edgesIgnoringSafeArea(.all)
            Text("Vos matchs favoris s'afficheront ici.")
                .foregroundColor(.white)
                .padding()
        }
    }
}
