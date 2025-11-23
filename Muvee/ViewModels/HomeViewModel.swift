import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    @Published var genres: [Genre] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let tmdbService = TMDBService.shared
    
    @MainActor
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let trending = tmdbService.fetchTrending()
            async let popular = tmdbService.fetchPopular()
            async let topRated = tmdbService.fetchTopRated()
            async let genreList = tmdbService.fetchGenres()
            
            let (trendingResult, popularResult, topRatedResult, genreResult) = try await (trending, popular, topRated, genreList)
            
            self.trendingMovies = trendingResult
            self.popularMovies = popularResult
            self.topRatedMovies = topRatedResult
            self.genres = genreResult
            
        } catch {
            self.errorMessage = "Failed to load movies: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
