import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    private var preferences = PreferencesService.shared
    
    var isDarkMode: Bool {
        get { preferences.isDarkMode }
        set { preferences.isDarkMode = newValue }
    }
    
    let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
}
