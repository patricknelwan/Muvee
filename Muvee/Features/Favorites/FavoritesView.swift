import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteMovie.timestamp, order: .reverse) private var favorites: [FavoriteMovie]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
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
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                            ForEach(favorites) { favorite in
                                NavigationLink(destination: MovieDetailView(movie: Movie(
                                    id: favorite.id,
                                    title: favorite.title,
                                    overview: "",
                                    posterPath: favorite.posterPath,
                                    backdropPath: nil,
                                    releaseDate: nil,
                                    voteAverage: 0.0,
                                    genreIds: nil
                                ))) {
                                    MovieCard(movie: Movie(
                                        id: favorite.id,
                                        title: favorite.title,
                                        overview: "",
                                        posterPath: favorite.posterPath,
                                        backdropPath: nil,
                                        releaseDate: nil,
                                        voteAverage: 0.0,
                                        genreIds: nil
                                    ))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contextMenu {
                                    Button(role: .destructive) {
                                        modelContext.delete(favorite)
                                    } label: {
                                        Label("Remove from Favorites", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("Favorites")
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    

}
