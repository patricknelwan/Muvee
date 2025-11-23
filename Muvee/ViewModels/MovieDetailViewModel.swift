import SwiftUI
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie
    @Published var cast: [CastMember] = []
    @Published var isLoading = false
    
    private let tmdbService = TMDBService.shared
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    @MainActor
    func loadDetails() async {
        isLoading = true
        do {
            // Fetch full details (in case we only have partial data from list)
            let fullDetails = try await tmdbService.fetchMovieDetails(id: movie.id)
            self.movie = fullDetails
            
            // Fetch cast
            let castMembers = try await tmdbService.fetchCredits(id: movie.id)
            self.cast = castMembers
        } catch {
            print("Error loading details: \(error)")
        }
        isLoading = false
    }
}
