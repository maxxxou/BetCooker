import Foundation

struct MatchOdds: Codable {
    let id: String
    let sportKey: String
    let sportTitle: String
    let commenceTime: String
    let homeTeam: String
    let awayTeam: String
    let bookmakers: [Bookmaker]

    enum CodingKeys: String, CodingKey {
        case id
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case bookmakers
    }
}

struct Bookmaker: Codable {
    let key: String
    let title: String
    let markets: [Market]

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case markets
    }
}

struct Market: Codable {
    let key: String
    let outcomes: [Outcome]

    enum CodingKeys: String, CodingKey {
        case key
        case outcomes
    }
}

struct Outcome: Codable {
    let name: String
    let price: Double

    enum CodingKeys: String, CodingKey {
        case name
        case price
    }
}


class APIService {
    static let shared = APIService()
    
    private let apiKey = "a140c17bce16adaaf8f47deef38c12a3"
    
    func fetchTennisOdds(completion: @escaping (Result<[MatchOdds], Error>) -> Void) {
        let urlString = """
        https://api.the-odds-api.com/v4/sports/tennis/odds?regions=eu&markets=h2h&oddsFormat=decimal&apiKey=\(apiKey)
        """
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Bad URL", code: 0)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            let raw = String(data: data, encoding: .utf8) ?? "No string"
            print("📦 Raw response:\n\(raw)")
            
            do {
                            let matches = try JSONDecoder().decode([MatchOdds].self, from: data)
                            
                            // 🎯 Print structuré
                            for match in matches {
                                print("🏟️ \(match.homeTeam) vs \(match.awayTeam) à \(match.commenceTime)")
                                for bookmaker in match.bookmakers {
                                    print("  📖 Bookmaker: \(bookmaker.title)")
                                    for market in bookmaker.markets {
                                        print("    📊 Market: \(market.key)")
                                        for outcome in market.outcomes {
                                            print("      → \(outcome.name): \(outcome.price)")
                                        }
                                    }
                                }
                                print("----------")
                            }
                            
                            completion(.success(matches))
                        } catch {
                            print("❌ Erreur de décodage JSON:", error)
                            completion(.failure(error))
                        }
        }
        
        
        task.resume()
    }
}
