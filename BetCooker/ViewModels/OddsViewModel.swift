import Foundation

class OddsViewModel: ObservableObject {
    @Published var matches: [MatchOdds] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchOdds() {
        isLoading = true
        errorMessage = nil

        APIService.shared.fetchOdds { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.matches = data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

