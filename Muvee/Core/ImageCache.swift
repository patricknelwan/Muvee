import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // Optional: Configure cache limits if needed
        // cache.countLimit = 100
        // cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
    }
    
    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func get(for url: URL) -> UIImage? {
        return cache.object(forKey: url.absoluteString as NSString)
    }
}
