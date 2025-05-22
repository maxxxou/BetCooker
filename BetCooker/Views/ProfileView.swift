import SwiftUI;

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color(hex: "#121212").edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                Text("Nom d'utilisateur")
                    .foregroundColor(.white)
                    .font(.title3)
                Button(action: {
                    // Logout or future config
                }) {
                    Text("Déconnexion")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#F15BB5"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
    }
}
