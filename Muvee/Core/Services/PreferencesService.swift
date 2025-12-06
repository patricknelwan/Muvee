import Foundation
import SwiftUI
import Combine

class PreferencesService: ObservableObject {
    
    static let shared = PreferencesService()
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    private init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
}
