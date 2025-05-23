import SwiftUI

struct MatchesView: View {
    @StateObject var viewModel = OddsViewModel()
    @State private var searchText: String = ""

    var filteredMatches: [MatchOdds] {
        if searchText.isEmpty {
            return viewModel.matches
        } else {
            return viewModel.matches.filter {
                $0.homeTeam.localizedCaseInsensitiveContains(searchText) ||
                $0.awayTeam.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Spacer(minLength: 0)
                TextField("Search team", text: $searchText)
                    .padding(15)
                    .background(Color(hex: "#1F1F2E"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                ZStack {
                    Color(hex: "#000000").edgesIgnoringSafeArea(.all)

                    if viewModel.isLoading {
                        ProgressView("Chargement…")
                            .foregroundColor(.white)
                    } else if let error = viewModel.errorMessage {
                        Text("Erreur : \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredMatches, id: \.id) { match in
                                    NavigationLink(destination: MatchDetailView(match: match)) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(match.homeTeam)")
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                                Text("VS")
                                                    .foregroundColor(Color(hex: "#9B5DE5"))
                                                    .font(.caption)
                                                Text("\(match.awayTeam)")
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                            }
                                            Spacer()
                                            VStack {
                                                Text("\(match.commenceTime.prefix(16).replacingOccurrences(of: "T", with: " "))")
                                                    .font(.caption2)
                                                    .foregroundColor(Color(hex: "#B0B0B0"))
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(Color(hex: "#9B5DE5"))
                                            }
                                        }
                                        .padding()
                                        .background(Color(hex: "#1F1F2E"))
                                        .cornerRadius(12)
                                        .shadow(radius: 2)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top)
                        }
                    }
                }
            }
            .navigationTitle("Matchs")
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear { viewModel.fetchOdds() }
        }
    }
}
