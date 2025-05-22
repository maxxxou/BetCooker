import SwiftUI

struct MatchesView: View {
    @StateObject var viewModel = OddsViewModel()
    @State private var selectedBookmaker: String = "All"

    var filteredMatches: [MatchOdds] {
        if selectedBookmaker == "All" {
            return viewModel.matches
        } else {
            return viewModel.matches.filter { match in
                match.bookmakers.contains { $0.title == selectedBookmaker }
            }
        }
    }

    var uniqueBookmakers: [String] {
        let all = viewModel.matches.flatMap { $0.bookmakers.map { $0.title } }
        return ["All"] + Array(Set(all)).sorted()
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Bookmaker", selection: $selectedBookmaker) {
                    ForEach(uniqueBookmakers, id: \ .self) { bookmaker in
                        Text(bookmaker).tag(bookmaker)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ZStack {
                    Color(hex: "#121212").edgesIgnoringSafeArea(.all)

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
                .navigationTitle("Matchs")
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear { viewModel.fetchOdds() }
            }
        }
    }
}
