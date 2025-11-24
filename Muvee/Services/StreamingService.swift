import Foundation

struct StreamingService {
    static let shared = StreamingService()
    
    // Vidking Embed Base URL
    private let vidkingBaseURL = "https://www.vidking.net/embed/movie/"
    private let cinebyBaseURL = "https://www.cineby.gd/movie/"
    
    enum StreamingSource: String, CaseIterable, Identifiable {
        case vidking = "Source 1"
        case cineby = "Source 2"
        
        var id: String { self.rawValue }
    }
    
    func getStreamURL(for movieId: Int, source: StreamingSource) -> URL? {
        let urlString: String
        switch source {
        case .vidking:
            urlString = "\(vidkingBaseURL)\(movieId)"
        case .cineby:
            urlString = "\(cinebyBaseURL)\(movieId)"
        }
        return URL(string: urlString)
    }
}
