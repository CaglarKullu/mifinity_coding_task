import '../models/movie.dart';

class MovieState {
  final List<Movie> movies;
  final bool isLoading;
  final String? error;

  MovieState({
    required this.movies,
    this.isLoading = false,
    this.error,
  });

  MovieState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? error,
  }) {
    return MovieState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
