import SwiftUI
import SwiftData

struct MovieDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteMovie]
    @StateObject private var viewModel: MovieDetailViewModel
    @State private var showPlayer = false
    
    var isFavorite: Bool {
        favorites.contains { $0.id == viewModel.movie.id }
    }
    
    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image
                CachedAsyncImage(url: viewModel.movie.backdropURL ?? viewModel.movie.posterURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8)]), startPoint: .center, endPoint: .bottom)
                            )
                    default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title & Info
                    Text(viewModel.movie.title)
                        .font(.largeTitle)
                        .bold()
                    
                    HStack {
                        Text(viewModel.movie.yearText)
                        Text("•")
                        Text("Rating: \(String(format: "%.1f", viewModel.movie.voteAverage))")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        // Watch Button
                        Button(action: {
                            showPlayer = true
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Watch Now")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        // Favorite Button
                        Button(action: toggleFavorite) {
                            HStack {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                Text(isFavorite ? "Saved" : "Favorite")
                            }
                            .font(.headline)
                            .foregroundColor(isFavorite ? .red : .primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.vertical)
                    
                    // Overview
                    Text("Overview")
                        .font(.title3)
                        .bold()
                    Text(viewModel.movie.overview)
                        .font(.body)
                        .lineSpacing(4)
                    
                    // Cast
                    if !viewModel.cast.isEmpty {
                        Text("Cast")
                            .font(.title3)
                            .bold()
                            .padding(.top)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.cast) { member in
                                    VStack {
                                        CachedAsyncImage(url: member.profileURL) { phase in
                                            if let image = phase.image {
                                                image.resizable().aspectRatio(contentMode: .fill)
                                            } else {
                                                Circle().fill(Color.gray.opacity(0.3))
                                            }
                                        }
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        
                                        Text(member.name)
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 80)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .task {
            await viewModel.loadDetails()
        }
        .sheet(isPresented: $showPlayer) {
            SourceSelectionView(movieId: viewModel.movie.id, isPresented: $showPlayer)
        }
    }
    
    private func toggleFavorite() {
        if isFavorite {
            if let favorite = favorites.first(where: { $0.id == viewModel.movie.id }) {
                modelContext.delete(favorite)
            }
        } else {
            let favorite = FavoriteMovie(
                id: viewModel.movie.id,
                title: viewModel.movie.title,
                posterPath: viewModel.movie.posterPath
            )
            modelContext.insert(favorite)
        }
    }
}

struct SourceSelectionView: View {
    let movieId: Int
    @Binding var isPresented: Bool
    @State private var selectedSource: StreamingService.StreamingSource = .vidking
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Streaming Source")
                    .font(.title2)
                    .bold()
                
                Picker("Source", selection: $selectedSource) {
                    ForEach(StreamingService.StreamingSource.allCases) { source in
                        Text(source.rawValue).tag(source)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if let url = StreamingService.shared.getStreamURL(for: movieId, source: selectedSource) {
                    PlayerWebView(url: url)
                        .edgesIgnoringSafeArea(.bottom)
                } else {
                    Text("Stream URL not available")
                }
            }
            .navigationBarItems(trailing: Button("Close") {
                isPresented = false
            })
        }
    }
}
