import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
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
                
                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search movies...", text: $viewModel.query)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !viewModel.query.isEmpty {
                            Button(action: {
                                viewModel.query = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(
                        GlassView(style: .systemUltraThinMaterial)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .padding()
                    
                    // Content
                    ZStack(alignment: .top) {
                        if viewModel.isLoading && viewModel.results.isEmpty {
                            ProgressView()
                                .frame(maxHeight: .infinity)
                        } else if let error = viewModel.error {
                            VStack(spacing: 16) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 50))
                                    .foregroundColor(.orange)
                                Text("Something went wrong")
                                    .font(.headline)
                                Text(error.localizedDescription)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                Button("Try Again") {
                                    Task {
                                        await viewModel.search(query: viewModel.query)
                                    }
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                            .background(GlassView(style: .systemThinMaterial))
                            .cornerRadius(16)
                            .padding()
                            .frame(maxHeight: .infinity)
                        } else if viewModel.results.isEmpty && !viewModel.query.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("No results found")
                                    .font(.headline)
                                Text("Try searching for something else")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(GlassView(style: .systemThinMaterial))
                            .cornerRadius(16)
                            .padding()
                            .frame(maxHeight: .infinity)
                        } else if viewModel.query.isEmpty {
                            // Browse by Genre
                            ScrollView {
                                VStack(alignment: .leading) {
                                    Text("Browse by Genre")
                                        .font(.title2)
                                        .bold()
                                        .padding(.horizontal)
                                        .padding(.top)
                                    
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                                        ForEach(viewModel.genres) { genre in
                                            NavigationLink(destination: GenreMoviesView(genre: genre)) {
                                                Text(genre.name)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 16)
                                                    .background(GlassView(style: .systemThinMaterial))
                                                    .cornerRadius(12)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding()
                                }
                            }
                        } else {
                            ScrollView {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                                    ForEach(viewModel.results) { movie in
                                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                                            MovieCard(movie: movie)
                                                .onAppear {
                                                    if movie == viewModel.results.last {
                                                        Task {
                                                            await viewModel.loadMore()
                                                        }
                                                    }
                                                }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    
                                    if viewModel.canLoadMore {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                    }
                                }
                                .padding()
                            }
                            .simultaneousGesture(DragGesture().onChanged { _ in
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            })
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Search")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}
