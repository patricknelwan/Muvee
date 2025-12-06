import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Movie] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var canLoadMore = false
    @Published var genres: [Genre] = []
    
    private let tmdbService = TMDBService.shared
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var totalPages = 1
    private var searchTask: Task<Void, Never>?
    
    init() {
        Task {
            do {
                self.genres = try await tmdbService.fetchGenres()
            } catch {
                print("Failed to load genres: \(error)")
            }
        }
        
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.searchTask?.cancel()
                self?.searchTask = Task {
                    await self?.search(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    func search(query: String) async {
        guard !query.isEmpty else {
            results = []
            error = nil
            canLoadMore = false
            return
        }
        
        isLoading = true
        error = nil
        currentPage = 1
        
        do {
            let (newResults, total) = try await tmdbService.searchMovies(query: query, page: 1)
            if !Task.isCancelled {
                results = newResults
                totalPages = total
                canLoadMore = currentPage < totalPages
            }
        } catch {
            if !Task.isCancelled {
                self.error = error
                results = []
            }
        }
        if !Task.isCancelled {
            isLoading = false
        }
    }
    
    func loadMore() async {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        currentPage += 1
        
        do {
            let (newResults, _) = try await tmdbService.searchMovies(query: query, page: currentPage)
            results.append(contentsOf: newResults)
            canLoadMore = currentPage < totalPages
        } catch {
            self.error = error
            currentPage -= 1 // Revert page increment on failure
        }
        isLoading = false
    }
}
