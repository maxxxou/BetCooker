import SwiftUI

struct LiveMatchesView: View {
    @StateObject var viewModel = OddsViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#000000").edgesIgnoringSafeArea(.all)

                if viewModel.isLoading {
                    ProgressView(NSLocalizedString("Loading…", comment: "Indicateur de chargement"))
                        .foregroundColor(.white)
                } else if let error = viewModel.errorMessage {
                    Text(String(format: NSLocalizedString("Error: %@", comment: "Message d'erreur avec détail"), error))
                        .foregroundColor(.red)
                        .padding()
                } else {
                    let now = Date()
                    let upcomingThreshold = now.addingTimeInterval(2 * 3600)

                    let upcomingMatches = viewModel.matches.filter { match in
                        guard let date = ISO8601DateFormatter().date(from: match.commenceTime) else { return false }
                        return date > now && date <= upcomingThreshold
                    }

                    let liveMatches = viewModel.matches.filter { match in
                        guard let date = ISO8601DateFormatter().date(from: match.commenceTime) else { return false }
                        return date <= now
                    }

                    ScrollView {
                        VStack(spacing: 20) {
                            if !liveMatches.isEmpty {
                                ForEach(liveMatches, id: \.id) { match in
                                    LiveMatchCard(match: match, isUpcoming: false)
                                }
                            }

                            if !upcomingMatches.isEmpty {
                                ForEach(upcomingMatches, id: \.id) { match in
                                    LiveMatchCard(match: match, isUpcoming: true)
                                }
                            }

                            if liveMatches.isEmpty && upcomingMatches.isEmpty {
                                Text(NSLocalizedString("No live matches at the moment.", comment: "Message quand aucun match en direct"))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("BetCooker", comment: "Titre principal de l'application"))
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear { viewModel.fetchOdds() }
        }
    }
}

struct LiveMatchCard: View {
    let match: MatchOdds
    let isUpcoming: Bool

    func countdownString() -> String? {
        guard let matchDate = ISO8601DateFormatter().date(from: match.commenceTime) else { return nil }

        let interval = Int(matchDate.timeIntervalSince(Date()))
        guard interval > 0 else { return nil }

        let hours = interval / 3600
        let minutes = (interval % 3600) / 60

        if hours > 0 {
            return String(format: NSLocalizedString("%dh %dm", comment: "Countdown heures et minutes"))
                .replacingOccurrences(of: "%d", with: "\(hours)", options: [], range: nil)
                .replacingOccurrences(of: "%d", with: "\(minutes)", options: [], range: nil)
            // Alternativement, gérer proprement via String(format:)
        } else {
            return String(format: NSLocalizedString("%dm", comment: "Countdown minutes"))
                .replacingOccurrences(of: "%d", with: "\(minutes)", options: [], range: nil)
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(match.homeTeam) vs \(match.awayTeam)")
                    .foregroundColor(isUpcoming ? .gray : .white)
                    .font(.headline)

                if isUpcoming {
                    HStack(spacing: 4) {
                        Image(systemName: "hourglass")
                        Text(NSLocalizedString("Starting soon", comment: "Match qui commence bientôt"))
                        if let countdown = countdownString() {
                            Text("· \(countdown)")
                        }
                    }
                    .foregroundColor(.gray)
                    .font(.caption)
                }
            }
            Spacer()
            if !isUpcoming {
                Image(systemName: "play.circle.fill")
                    .foregroundColor(Color(hex: "#9B5DE5"))
            }
        }
        .padding()
        .background(Color(hex: isUpcoming ? "#1A1A1A" : "#1F1F2E"))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}


