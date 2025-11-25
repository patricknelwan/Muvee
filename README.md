# Muvee

Muvee is a modern iOS movie discovery and streaming application built with SwiftUI. It allows users to browse trending movies, search for their favorites, and stream content directly within the app.

## Features

-   **Discover**: Browse Trending, Popular, and Top Rated movies.
-   **Genre Browsing**: Explore movies by specific genres.
-   **Search**: Find movies by title.
-   **Favorites**: Save your favorite movies to a personal list (persisted locally).
-   **Streaming**: Watch movies directly in the app using multiple streaming sources.
-   **Detailed Info**: View movie details, cast members, ratings, and overview.

## Technology Stack

-   **UI Framework**: SwiftUI
-   **Data Persistence**: SwiftData
-   **Architecture**: MVVM (Model-View-ViewModel)
-   **Networking**: URLSession, async/await
-   **API**: [The Movie Database (TMDB)](https://www.themoviedb.org/)

## Setup Instructions

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd Muvee
    ```

2.  **API Configuration**:
    This project uses the TMDB API. You need to obtain an API key from [TMDB](https://www.themoviedb.org/settings/api).

    Create a file named `Secrets.swift` inside the `Muvee/` directory (same level as `MuveeApp.swift`):

    ```swift
    // Muvee/Secrets.swift
    import Foundation

    struct Secrets {
        static let tmdbApiKey = "YOUR_TMDB_API_KEY_HERE"
    }
    ```

    > **Note**: `Secrets.swift` is added to `.gitignore` to keep your API key secure.

3.  **Open in Xcode**:
    Open `Muvee.xcodeproj` in Xcode.

4.  **Run**:
    Select a simulator or connected device and press `Cmd + R` to run the app.

## Requirements

-   iOS 17.0+
-   Xcode 15.0+

## License

This project is for educational purposes.
