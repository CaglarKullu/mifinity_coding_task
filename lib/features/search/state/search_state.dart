import '../../../core/errors/app_error.dart';
import '../../dashboard/models/movie.dart';

sealed class SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<Movie> movies;

  SearchLoadedState(this.movies);
}

class SearchErrorState extends SearchState {
  final AppError error;

  SearchErrorState(this.error);
}

class SearchEmptyState extends SearchState {}
