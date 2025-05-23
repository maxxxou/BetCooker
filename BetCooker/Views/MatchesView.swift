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
                TextField(NSLocalizedString("Search team", comment: "Placeholder pour rechercher une équipe"), text: $searchText)
                    .padding(15)
                    .background(Color(hex: "#1F1F2E"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                ZStack {
                    Color(hex: "#000000").edgesIgnoringSafeArea(.all)

                    if viewModel.isLoading {
                        ProgressView(NSLocalizedString("Loading…", comment: "Indicateur de chargement"))
                            .foregroundColor(.white)
                    } else if let error = viewModel.errorMessage {
                        Text(String(format: NSLocalizedString("ERROR : %@", comment: "Message d'erreur avec détail"), error))
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        MatchListScrollView(filteredMatches: filteredMatches)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("BetCooker", comment: "Titre principal de l'application"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear { viewModel.fetchOdds() }
        }
    }
}

struct MatchListScrollView: View {
    let filteredMatches: [MatchOdds]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredMatches, id: \.id) { match in
                    NavigationLink(destination: MatchDetailView(match: match)) {
                        HStack {
                            AnotherView(match: match)
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

struct AnotherView: View {
    let match: MatchOdds

    func formattedDate(from isoString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        guard let date = inputFormatter.date(from: isoString) else {
            return NSLocalizedString("Unknown date", comment: "Date inconnue")
        }

        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(date)

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.dateFormat = "HH:mm"

        let fullFormatter = DateFormatter()
        fullFormatter.locale = Locale.current
        fullFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        let todayText = NSLocalizedString("Today", comment: "Aujourd'hui")
        return isToday ? "\(todayText) - \(timeFormatter.string(from: date))" : fullFormatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(match.homeTeam)
                .foregroundColor(.white)
                .font(.headline)
            Text(NSLocalizedString("VS", comment: "Versus entre deux équipes"))
                .foregroundColor(Color(hex: "#9B5DE5"))
                .font(.caption)
            Text(match.awayTeam)
                .foregroundColor(.white)
                .font(.headline)
        }
        Spacer()
        VStack(alignment: .trailing, spacing: 2) {
            Text(formattedDate(from: match.commenceTime))
                .font(.subheadline.bold())
                .foregroundColor(Color(hex: "#B0B0B0"))
                .padding(.bottom, 25)
            Image(systemName: "chevron.right")
                .foregroundColor(Color(hex: "#9B5DE5"))
        }
    }
}


