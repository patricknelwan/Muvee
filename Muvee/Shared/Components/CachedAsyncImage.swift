import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    @State private var phase: AsyncImagePhase
    
    init(
        url: URL?,
        scale: CGFloat = 1,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        
        // Initialize phase based on cache availability
        if let url = url, let cachedImage = ImageCache.shared.get(for: url) {
            self._phase = State(initialValue: .success(Image(uiImage: cachedImage)))
        } else {
            self._phase = State(initialValue: .empty)
        }
    }
    
    var body: some View {
        content(phase)
            .task(id: url) {
                await load()
            }
    }
    
    private func load() async {
        guard let url = url else {
            phase = .empty
            return
        }
        
        // Check cache again (in case it was added since init)
        if let cachedImage = ImageCache.shared.get(for: url) {
            phase = .success(Image(uiImage: cachedImage))
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.set(uiImage, for: url)
                withAnimation(transaction.animation) {
                    phase = .success(Image(uiImage: uiImage))
                }
            } else {
                phase = .failure(URLError(.badServerResponse))
            }
        } catch {
            phase = .failure(error)
        }
    }
}


