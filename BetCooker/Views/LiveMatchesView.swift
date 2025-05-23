import SwiftUI

struct LiveMatchesView: View {
    @StateObject var viewModel = OddsViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#000000").edgesIgnoringSafeArea(.all)

                if viewModel.isLoading {
                    ProgressView("Loading…")
                        .foregroundColor(.white)
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
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
                                Text("No live matches at the moment.")
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
                    Text("BetCooker")
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
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
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
                        Text("Starting soon")
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
