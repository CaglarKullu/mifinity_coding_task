import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../models/movie_state.dart';
import '../repositories/i_movie_repository.dart';
import '../repositories/movie_repository.dart';
import '../services/tmdb_service.dart';

class MovieViewModel extends StateNotifier<MovieState> {
  final MovieRepositoryInterface repository;
  final TMDbService tmdbService;

  MovieViewModel(this.repository, this.tmdbService)
      : super(MovieState(movies: [])) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    await repository.init(); // Ensure the repository is initialized
    // Check if the database has any movies
    final existingMovies = await repository.getMovies();
    if (existingMovies.isEmpty) {
      // If no movies in the database, populate from TMDb
      await _populateMovies();
    }
    _loadMovies();
    state = state.copyWith(isLoading: false);
  }

  Future<void> _populateMovies() async {
    try {
      final movies = await tmdbService.fetchPopularMovies();
      for (var movie in movies) {
        await repository.addMovie(movie);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> _loadMovies() async {
    try {
      state = state.copyWith(isLoading: true);
      final movies = await repository.getMovies();
      state = state.copyWith(movies: movies, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addMovie(Movie movie) async {
    try {
      await repository.addMovie(movie);
      _loadMovies(); // Reload movies after adding a new one
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteMovie(int id) async {
    try {
      await repository.deleteMovie(id);
      _loadMovies(); // Reload movies after deletion
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final movieRepositoryProvider = Provider<MovieRepositoryInterface>((ref) {
  final repo = MovieRepository();
  repo.init();
  return repo;
});

final movieViewModelProvider =
    StateNotifierProvider<MovieViewModel, MovieState>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  final tmdbService = TMDbService('cb90cfa7513d25d90fe3138a17e20f51');
  return MovieViewModel(repository, tmdbService);
});
