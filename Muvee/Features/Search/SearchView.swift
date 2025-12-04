import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search movies...", text: $viewModel.query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                        ForEach(viewModel.results) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieCard(movie: movie)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Search")
        }
        .navigationViewStyle(.stack)
    }
}
