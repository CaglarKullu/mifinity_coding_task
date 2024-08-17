import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../data/repositories/i_movie_repository.dart';
import '../data/repositories/movie_repository.dart';
import '../data/services/tmdb_service.dart';
import '../../../core/errors/app_error.dart';
import 'movie_state.dart';

class MovieViewModel extends StateNotifier<MovieState> {
  final MovieRepositoryInterface repository;
  final TMDbService tmdbService;

  MovieViewModel(this.repository, this.tmdbService)
      : super(MovieLoadingState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await repository.init(); // Ensure the repository is initialized
    } catch (e) {
      state = MovieErrorState(
          DatabaseError("Failed to initialize the database: ${e.toString()}"));
      return;
    }

    try {
      final existingMovies = await repository.getMovies();
      if (existingMovies.isEmpty) {
        await _populateMovies(tmdbService.fetchPopularMovies());
        await _populateMovies(tmdbService.fetchTopRatedMovies());
        await _populateMovies(tmdbService.fetchUpcomingMovies());
        await _populateMovies(tmdbService.fetchNowPlayingMovies());
      } else {
        state = MovieLoadedState(existingMovies);
      }
    } catch (e) {
      state = MovieErrorState(DatabaseError(
          "Failed to load movies from the database: ${e.toString()}"));
    }
  }

  Future<void> _populateMovies(Future<List<Movie>> tmdbSercviceFuction) async {
    try {
      final movies = await tmdbSercviceFuction;
      for (var movie in movies) {
        await repository.addMovie(movie);
      }
      _loadMovies(); // Reload movies after populating
    } catch (e) {
      if (e is AppError) {
        state = MovieErrorState(e); // Directly passing the AppError instance
      } else {
        state = MovieErrorState(
            UnknownError("An unknown error occurred: ${e.toString()}"));
      }
    }
  }

  Future<void> _loadMovies() async {
    try {
      final movies = await repository.getMovies();
      if (movies.isEmpty) {
        state = MovieEmptyState();
      } else {
        state = MovieLoadedState(movies);
      }
    } catch (e) {
      state = MovieErrorState(DatabaseError(
          "Failed to load movies from the database: ${e.toString()}"));
    }
  }

// get more movies

  Future<List<Movie>> getMoreMovies() async {
    try {
      final movies = await tmdbService.fetchPopularMovies();
      return movies;
    } catch (e) {
      if (e is AppError) {
        state = MovieErrorState(e); // Directly passing the AppError instance
      } else {
        state = MovieErrorState(
            UnknownError("An unknown error occurred: ${e.toString()}"));
      }
      return [];
    }
  }

  // get posters links

  Future<List<String>> getPosterLinks(List<Movie> movies) async {
    final posterLinks = <String>[];
    for (var movie in movies) {
      final posterUrl = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';
      posterLinks.add(posterUrl);
    }
    return posterLinks;
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final movies = await repository.getTopRatedMovies();
    return movies;
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final movies = await repository.getUpcomingMovies();
    return movies;
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    final movies = await repository.getNowPlayingMovies();
    return movies;
  }

  Future<List<Movie>> getPopularMovies() async {
    final movies = await repository.getPopularMovies();
    return movies;
  }
}

//Providers

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});

final movieViewModelProvider =
    StateNotifierProvider<MovieViewModel, MovieState>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  final tmdbService = TMDbService(dotenv.env['TMDB_API_KEY']!);
  return MovieViewModel(repository, tmdbService);
});
