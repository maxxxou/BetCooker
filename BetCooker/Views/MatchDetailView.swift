import SwiftUI

struct MatchDetailView: View {
    let match: MatchOdds

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(match.homeTeam) vs \(match.awayTeam)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Text("\(match.commenceTime.prefix(16).replacingOccurrences(of: "T", with: " "))")
                    .foregroundColor(Color(hex: "#121212"))

                ForEach(match.bookmakers, id: \.key) { bookmaker in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(bookmaker.title)")
                            .foregroundColor(.white)
                            .font(.headline)

                        ForEach(bookmaker.markets, id: \.key) { market in
                            VStack(alignment: .leading) {
                                Text("Marché : \(market.key)")
                                    .foregroundColor(Color(hex: "#b0b0b0"))
                                    .font(.subheadline)

                                ForEach(market.outcomes, id: \.name) { outcome in
                                    HStack {
                                        Text(outcome.name)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text(String(format: "%.2f", outcome.price))
                                            .foregroundColor(Color(hex: "#F15BB5"))
                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(hex: "#1F1F2E"))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .background(Color(hex: "#121212"))
        .navigationTitle("Détails")
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
