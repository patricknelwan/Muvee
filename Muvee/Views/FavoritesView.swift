import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteMovie.timestamp, order: .reverse) private var favorites: [FavoriteMovie]
    
    var body: some View {
        NavigationView {
            if favorites.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No favorites yet")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Mark movies as favorites to see them here.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .navigationTitle("Favorites")
            } else {
                List {
                    ForEach(favorites) { favorite in
                        NavigationLink(destination: MovieDetailView(movie: Movie(
                            id: favorite.id,
                            title: favorite.title,
                            overview: "", // We might need to fetch full details if not stored, but for now we pass basic info
                            posterPath: favorite.posterPath,
                            backdropPath: nil,
                            releaseDate: nil,
                            voteAverage: 0.0,
                            genreIds: nil
                        ))) {
                            HStack {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(favorite.posterPath ?? "")")) { phase in
                                    if let image = phase.image {
                                        image.resizable().aspectRatio(contentMode: .fill)
                                    } else {
                                        Rectangle().fill(Color.gray.opacity(0.3))
                                    }
                                }
                                .frame(width: 50, height: 75)
                                .cornerRadius(4)
                                
                                Text(favorite.title)
                                    .font(.headline)
                            }
                        }
                    }
                    .onDelete(perform: deleteFavorites)
                }
                .navigationTitle("Favorites")
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteFavorites(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(favorites[index])
            }
        }
    }
}
