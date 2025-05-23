import SwiftUI

let bookmakerLinks: [String: String] = [
    "unibet": "https://www.unibet.fr",
    "nordic bet": "https://www.nordicbet.com",
    "betclic": "https://www.betclic.fr",
    "pinnacle": "https://www.pinnacle.com",
    "winamax (fr)": "https://www.winamax.fr",
    "winamax (de)": "https://www.winamax.de",
    "betsson": "https://www.betsson.com",
    "coolbet": "https://www.coolbet.com",
    "tipico": "https://www.tipico.com",
    "betfair": "https://www.betfair.com",
    "matchbook": "https://www.matchbook.com",
    "parions sport (fr)": "https://www.enligne.parionssport.fdj.fr",
    "1xbet": "https://1xbet.com",
    "maraton bet": "https://www.marathonbet.com",
    "gtbets": "https://www.gtbets.eu",
    "william hill": "https://www.williamhill.com",
    "every game": "https://www.everygame.eu",
    "betonline.ag": "https://www.betonline.ag",
    "betanysports": "https://www.betanysports.eu"
]

struct MatchDetailView: View {
    let match: MatchOdds
    @State private var homeTeamLogoURL: String?
    @State private var awayTeamLogoURL: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // 🏷️ Équipes + logos
                VStack(spacing: 6) {
                    HStack(spacing: 12) {
                        if let homeLogo = homeTeamLogoURL, let url = URL(string: homeLogo) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 26, height: 26)
                            .clipShape(Circle())
                        }

                        Text(match.homeTeam)
                            .foregroundColor(.white)
                            .font(.headline)

                        Text("vs")
                            .foregroundColor(Color(hex: "#9B5DE5"))
                            .font(.headline)

                        Text(match.awayTeam)
                            .foregroundColor(.white)
                            .font(.headline)

                        if let awayLogo = awayTeamLogoURL, let url = URL(string: awayLogo) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 26, height: 26)
                            .clipShape(Circle())
                        }
                    }
                    .frame(maxWidth: .infinity)

                    if let date = ISO8601DateFormatter().date(from: match.commenceTime),
                       Calendar.current.isDateInToday(date) {
                        Text(date.formatted(date: .omitted, time: .shortened))
                            .foregroundColor(Color(hex: "#B0B0B0"))
                            .font(.subheadline)
                    }
                }

                // 🧾 Bookmakers & Markets
                ForEach(match.bookmakers, id: \.key) { bookmaker in
                    VStack(alignment: .leading, spacing: 14) {
                        let key = bookmaker.title.lowercased()
                        if let urlString = bookmakerLinks[key], let url = URL(string: urlString) {
                            Link(destination: url) {
                                Text(bookmaker.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color(hex: "#1F1F2E"))
                                    .cornerRadius(14)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        } else {
                            Text(bookmaker.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color(hex: "#1F1F2E"))
                                .cornerRadius(14)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        ForEach(bookmaker.markets, id: \.key) { market in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(String(format: NSLocalizedString("Market: %@", comment: "Label for market key in match details"), market.key))
                                    .font(.footnote)
                                    .foregroundColor(Color(hex: "#B0B0B0"))

                                let outcomes = market.outcomes
                                if outcomes.count == 3 {
                                    HStack(spacing: 12) {
                                        ForEach(outcomes, id: \.name) { outcome in
                                            OutcomeButton(outcome: outcome)
                                        }
                                    }
                                } else {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                        ForEach(outcomes, id: \.name) { outcome in
                                            OutcomeButton(outcome: outcome)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(hex: "#141417"))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
        .background(Color(hex: "#000000"))
        .navigationTitle(NSLocalizedString("Details", comment: "Navigation title for match details"))
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct OutcomeButton: View {
    let outcome: Outcome

    var body: some View {
        VStack(spacing: 4) {
            Text(outcome.name)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text(String(format: "%.2f", outcome.price))
                .font(.subheadline.bold())
                .foregroundColor(Color(hex: "#F15BB5"))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#1F1F2E"))
        .cornerRadius(16)
    }
}
