import SwiftUI

struct ScoresView: View {
    @State private var scores: [MatchScores] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#000000").edgesIgnoringSafeArea(.all)

                if isLoading {
                    ProgressView(NSLocalizedString("Loading scores…", comment: "Indicateur de chargement des scores"))
                        .foregroundColor(.white)
                } else if let errorMessage = errorMessage {
                    Text(String(format: NSLocalizedString("ERROR : %@", comment: "Message d'erreur avec détail"), errorMessage))
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(scores.filter { $0.completed }, id: \.id) { match in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(match.homeTeam) vs \(match.awayTeam)")
                                        .foregroundColor(.white)
                                        .font(.headline)

                                    ForEach(match.scores ?? [], id: \.name) { entry in
                                        HStack {
                                            Text("\(entry.name):")
                                                .foregroundColor(.gray)
                                            Text(entry.score)
                                                .foregroundColor(.white)
                                        }
                                        .font(.caption)
                                    }
                                }
                                .padding()
                                .background(Color(hex: "#1F1F2E"))
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Scores", comment: "Titre de la vue scores"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("BetCooker")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                APIService.shared.fetchScores { result in
                    DispatchQueue.main.async {
                        isLoading = false
                        switch result {
                        case .success(let data):
                            scores = data
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }
            }
        }
    }
}


