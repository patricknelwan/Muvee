import SwiftUI
import SwiftData

@main
struct MuveeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteMovie.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var preferences = PreferencesService.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(preferences.isDarkMode ? .dark : .light)
        }
        .modelContainer(sharedModelContainer)
    }
}
