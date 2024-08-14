import '../models/movie.dart';

sealed class MovieState {}

// State for when the movies are being loaded
class MovieLoadingState extends MovieState {}

// State for when movies are successfully loaded
class MovieLoadedState extends MovieState {
  final List<Movie> movies;

  MovieLoadedState(this.movies);
}

// State for when there is an error loading movies
class MovieErrorState extends MovieState {
  final String message;

  MovieErrorState(this.message);
}

// State for when no movies are available
class MovieEmptyState extends MovieState {}
