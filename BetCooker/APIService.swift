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

struct TennisScore: Codable {
    let id: String
    let sportKey: String
    let sportTitle: String
    let commenceTime: String
    let completed: Bool
    let homeTeam: String
    let awayTeam: String
    let scores: [ScoreEntry]?
    let lastUpdate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case completed
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case scores
        case lastUpdate = "last_update"
    }
}

struct ScoreEntry: Codable {
    let name: String
    let score: String
}



class APIService {
    static let shared = APIService()
    
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["ODDS_API_KEY"] as? String else {
            fatalError("❌ Impossible de charger la clé API")
        }
        return key
    }

    func fetchOdds(completion: @escaping (Result<[MatchOdds], Error>) -> Void) {
        let urlString = """
        https://api.the-odds-api.com/v4/sports/soccer/odds?regions=eu&markets=h2h,spreads,totals&oddsFormat=decimal&apiKey=\(apiKey)
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

            do {
                            let matches = try JSONDecoder().decode([MatchOdds].self, from: data)
                            
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
    
    func fetchScores(completion: @escaping (Result<[TennisScore], Error>) -> Void) {
        let urlString = "https://api.the-odds-api.com/v4/sports/soccer_france_ligue_one/scores/?daysFrom=3&apiKey=\(apiKey)"
        
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

            do {
                let scores = try JSONDecoder().decode([TennisScore].self, from: data)

                for match in scores {
                    print("⚽\(match.homeTeam) vs \(match.awayTeam) at \(match.commenceTime)")
                    if match.completed {
                        print("✅ Match completed")
                        match.scores?.forEach { entry in
                            print("→ \(entry.name): \(entry.score)")
                        }
                    } else {
                        print("🕒 Scheduled")
                    }
                    print("-----")
                }

                completion(.success(scores))
            } catch {
                print("❌ Decoding error:", error)
                completion(.failure(error))
            }
        }

        task.resume()
    }

}
