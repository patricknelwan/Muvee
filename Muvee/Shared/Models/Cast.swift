import Foundation

struct CastMember: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}

struct CreditsResponse: Codable {
    let id: Int
    let cast: [CastMember]
}
