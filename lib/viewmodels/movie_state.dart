import '../models/movie.dart';
import '../utils/app_error.dart';

abstract class MovieState {}

class MovieLoadingState extends MovieState {}

class MovieLoadedState extends MovieState {
  final List<Movie> movies;

  MovieLoadedState(this.movies);
}

class MovieErrorState extends MovieState {
  final AppError message;

  MovieErrorState(this.message);
}

class MovieEmptyState extends MovieState {}
