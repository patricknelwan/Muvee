import Foundation

struct StreamingService {
    static let shared = StreamingService()
    
    // Vidking Embed Base URL
    private let vidkingBaseURL = "https://www.vidking.net/embed/movie/"
    
    func getStreamURL(for movieId: Int) -> URL? {
        // Construct the embed URL
        // Example: https://www.vidking.net/embed/movie/12345
        let urlString = "\(vidkingBaseURL)\(movieId)"
        return URL(string: urlString)
    }
}
