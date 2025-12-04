import Foundation

actor TMDBService {
    static let shared = TMDBService()
    private let apiKey = Secrets.tmdbApiKey
    private let baseURL = "https://api.themoviedb.org/3"
    
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Endpoints
    
    enum Endpoint {
        case trending
        case topRated
        case popular
        case search(query: String)
        case details(id: Int)
        case credits(id: Int)
        case genres
        case discover(genreId: Int)
        
        var path: String {
            switch self {
            case .trending: return "/trending/movie/day"
            case .topRated: return "/movie/top_rated"
            case .popular: return "/movie/popular"
            case .search: return "/search/movie"
            case .details(let id): return "/movie/\(id)"
            case .credits(let id): return "/movie/\(id)/credits"
            case .genres: return "/genre/movie/list"
            case .discover: return "/discover/movie"
            }
        }
    }
    
    // MARK: - Fetching
    
    private func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        var components = URLComponents(string: baseURL + endpoint.path)!
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        if case .search(let query) = endpoint {
            queryItems.append(URLQueryItem(name: "query", value: query))
        }
        
        if case .discover(let genreId) = endpoint {
            queryItems.append(URLQueryItem(name: "with_genres", value: String(genreId)))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    // MARK: - Public Methods
    
    func fetchTrending() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(endpoint: .trending)
        return response.results
    }
    
    func fetchTopRated() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(endpoint: .topRated)
        return response.results
    }
    
    func fetchPopular() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(endpoint: .popular)
        return response.results
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        guard !query.isEmpty else { return [] }
        let response: MovieResponse = try await fetch(endpoint: .search(query: query))
        return response.results
    }
    
    func fetchMovieDetails(id: Int) async throws -> Movie {
        return try await fetch(endpoint: .details(id: id))
    }
    
    func fetchCredits(id: Int) async throws -> [CastMember] {
        let response: CreditsResponse = try await fetch(endpoint: .credits(id: id))
        return response.cast
    }
    
    func fetchGenres() async throws -> [Genre] {
        let response: GenreResponse = try await fetch(endpoint: .genres)
        return response.genres
    }
    
    func fetchMoviesByGenre(genreId: Int) async throws -> [Movie] {
        let response: MovieResponse = try await fetch(endpoint: .discover(genreId: genreId))
        return response.results
    }
}
