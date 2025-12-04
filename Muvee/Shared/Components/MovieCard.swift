import SwiftUI

struct MovieCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(Image(systemName: "film").foregroundColor(.gray))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 160, height: 240)
            .cornerRadius(12)
            .shadow(radius: 4)
            
            Text(movie.title)
                .font(.headline)
                .lineLimit(1)
                .foregroundColor(.primary)
            
            Text(movie.yearText)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: 160)
    }
}
