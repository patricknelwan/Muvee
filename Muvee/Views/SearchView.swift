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
                
                List(viewModel.results) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        HStack {
                            AsyncImage(url: movie.posterURL) { phase in
                                if let image = phase.image {
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } else {
                                    Rectangle().fill(Color.gray.opacity(0.3))
                                }
                            }
                            .frame(width: 50, height: 75)
                            .cornerRadius(4)
                            
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .font(.headline)
                                Text(movie.yearText)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Search")
        }
        .navigationViewStyle(.stack)
    }
}
