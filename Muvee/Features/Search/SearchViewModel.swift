import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Movie] = []
    @Published var isLoading = false
    
    private let tmdbService = TMDBService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                Task {
                    await self?.search(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    func search(query: String) async {
        guard !query.isEmpty else {
            results = []
            return
        }
        
        isLoading = true
        do {
            results = try await tmdbService.searchMovies(query: query)
        } catch {
            print("Search error: \(error)")
        }
        isLoading = false
    }
}
