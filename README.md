
# MiFinity Coding Task - Case Study

## Overview

This project is a Flutter-based mobile application developed as part of a coding task. It demonstrates the implementation of core features such as user authentication, dashboard, search functionality, and profile management. The application is structured following best practices, including the use of state management, service-oriented architecture, and clean code principles.

## Project Structure

### Core Modules

- **Utilities**: Located in `lib/core/utils`, this module includes various helper functions for validation, security, and general-purpose utilities.
- **Constants**: The `lib/core/consts` directory contains app-wide constants like colors and themes to ensure a consistent look and feel across the app.
- **Global Providers**: Managed in `lib/core/global_providers`, these providers offer a global state that can be accessed throughout the app.

### Features

- **Authentication**: 
  - **Models**: Defines user data structures (`user.dart`).
  - **Repositories**: Interfaces and implementations for authentication-related operations (`auth_repository.dart`, `auth_repository_interface.dart`).
  - **State Management**: Manages the authentication state (`auth_view_model.dart`, `auth_state.dart`).
  - **UI**: Presents the authentication screens to the user (`auth_screen.dart`).

  **Code Example**:
  ```dart
  // Example of a simple User model
    @Collection()
    class User {
    Id id = Isar.autoIncrement;

    late String email;
    String? password;
    late String passwordHash;
    late String salt;

    User({
    required this.email,
    required this.passwordHash,
    required this.salt,
    });
    @override
    String toString() {
    return 'User{id: $id, email: $email}';
  }
} ```

  ## **Dashboard**:
  - **Models**: Represents movies and genres (`movie.dart`, `genre.dart`).
  - **Repositories**: Handles data retrieval from services like TMDB (`movie_repository.dart`, `tmdb_service.dart`).
  - **State Management**: Manages the state of movies displayed on the dashboard (`movie_viewmodel.dart`, `movie_state.dart`).
  - **UI**: Dashboard screen and widgets (`dashboard_screen.dart`, `categories_list.dart`, `movie_list.dart`).

  **Code Example**:
  ```dart
  // Example of fetching movies from a repository
  class MovieRepository implements IMovieRepository {
    final TMDBService tmdbService;
    
    MovieRepository({required this.tmdbService});
    
    @override
    Future<List<Movie>> getPopularMovies() async {
      final response = await tmdbService.getPopularMovies();
      return response.results.map((json) => Movie.fromJson(json)).toList();
    }
  }
  ```

- **Search**:
  - **Repositories**: Manages search operations (`search_repository.dart`, `i_search_repository.dart`).
  - **State Management**: Manages the state of the search feature (`search_view_model.dart`, `search_state.dart`).
  - **UI**: Implements custom search UI components (`search_screen.dart`, `movie_search_delegate.dart`).

  **Code Example**:
  ```dart
  // Example of a Search ViewModel
  class SearchViewModel extends StateNotifier<SearchState> {
    final ISearchRepository searchRepository;

    SearchViewModel({required this.searchRepository}) : super(SearchState.initial());

    Future<void> searchMovies(String query) async {
      state = state.copyWith(isLoading: true);
      try {
        final results = await searchRepository.searchMovies(query);
        state = state.copyWith(movies: results, isLoading: false);
      } catch (e) {
        state = state.copyWith(error: e.toString(), isLoading: false);
      }
    }
  }
  ```

- **Profile**:
  - **UI**: Manages user profile presentation (`profile.dart`).

### Routing

- **App Router**: Routing is handled by `auto_route`, with configurations defined in `app_router.dart` and the generated file `app_router.gr.dart`.

**Code Example**:
```dart
// Example of auto route configuration
@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: MainScreen, initial: true),
    AutoRoute(page: AuthScreen),
    AutoRoute(page: DashboardScreen),
    AutoRoute(page: ProfileScreen),
  ],
)
class $AppRouter {}
```

### Entry Point

- **Main Application**: The application starts from `lib/main.dart`.

## Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the application**:
   ```bash
   flutter run
   ```

## Conclusion

This project showcases the implementation of a modular, well-architected Flutter application. It demonstrates the ability to manage state effectively, implement clean and maintainable code, and follow best practices in mobile development.
