import Foundation
import SwiftData

@Model
final class FavoriteMovie {
    @Attribute(.unique) var id: Int
    var title: String
    var posterPath: String?
    var timestamp: Date
    
    init(id: Int, title: String, posterPath: String?) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.timestamp = Date()
    }
}
