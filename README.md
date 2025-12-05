<div align="center">
  <img src="Images/MuveeIcon-iOS-Dark-1024x1024@1x.png" width="150" />
  <h1>Muvee</h1>
</div>

Muvee is an iOS movie discovery and streaming application built with SwiftUI. It allows users to browse trending movies, search for their favorites, and stream content directly within the app.

## Features

-   **Discover**: Browse Trending, Popular, and Top Rated movies.
-   **Genre Browsing**: Explore movies by specific genres.
-   **Search**: Find movies by title.
-   **Favorites**: Save your favorite movies to a personal list (persisted locally).
-   **Streaming**: Watch movies directly in the app using multiple streaming sources.
-   **Detailed Info**: View movie details, cast members, ratings, and overview.

## Screenshots

<p float="left">
  <img src="Images/Simulator Screenshot - iPad Pro 11-inch (M5) - 2025-12-05 at 09.59.03.png" width="45%" />
  <img src="Images/Simulator Screenshot - iPad Pro 11-inch (M5) - 2025-12-05 at 10.00.07.png" width="45%" /> 
</p>

## Technology Stack

-   **UI Framework**: SwiftUI
-   **Data Persistence**: SwiftData
-   **Architecture**: Feature-Modular MVVM (Model-View-ViewModel)
-   **Networking**: URLSession, async/await
-   **API**: [The Movie Database (TMDB)](https://www.themoviedb.org/)

## Project Structure

The project is organized into feature-based modules for better scalability and maintainability:

-   **App**: Application entry point and main configuration.
-   **Core**: Global services and configurations (e.g., TMDBService).
-   **Features**: Independent feature modules (Home, Search, Favorites, MovieDetail).
-   **Shared**: Reusable components and models used across features.
-   **Resources**: Assets and other resource files.

## Setup Instructions

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd Muvee
    ```

2.  **API Configuration**:
    This project uses the TMDB API. You need to obtain an API key from [TMDB](https://www.themoviedb.org/settings/api).

    Create a file named `Secrets.swift` inside the `Muvee/App/` directory:

    ```swift
    // Muvee/App/Secrets.swift
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
