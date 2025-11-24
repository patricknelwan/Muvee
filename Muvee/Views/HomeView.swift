import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if viewModel.isLoading {
                        ProgressView("Loading Movies...")
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        // Trending Section
                        MovieSection(title: "Trending Today", movies: viewModel.trendingMovies)
                        
                        // Popular Section
                        MovieSection(title: "Popular", movies: viewModel.popularMovies)
                        
                        // Top Rated Section
                        MovieSection(title: "Top Rated", movies: viewModel.topRatedMovies)
                        
                        // Genres Section
                        if !viewModel.genres.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Browse by Genre")
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(viewModel.genres) { genre in
                                            NavigationLink(destination: GenreMoviesView(genre: genre)) {
                                                Text(genre.name)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(Color.blue.opacity(0.1))
                                                    .cornerRadius(20)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(Color.blue, lineWidth: 1)
                                                    )
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Muvee")
            .task {
                await viewModel.loadData()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct MovieSection: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieCard(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
