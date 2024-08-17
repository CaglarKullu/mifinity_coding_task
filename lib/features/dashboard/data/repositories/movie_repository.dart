import 'package:isar/isar.dart';

import '../../models/movie.dart';
import 'i_movie_repository.dart';

class MovieRepository implements MovieRepositoryInterface {
  final Isar _isar;

  MovieRepository(this._isar);
  @override
  Future<void> init() async {}

  @override
  Future<void> addMovie(Movie movie) async {
    await _isar.writeTxn(() async {
      await _isar.movies.put(movie);
    });
  }

  @override
  Future<List<Movie>> getMovies() async {
    return await _isar.movies.where().findAll();
  }

  @override
  Future<void> deleteMovie(int id) async {
    await _isar.writeTxn(() async {
      await _isar.movies.delete(id);
    });
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() {
    return _isar.movies.filter().isNowPlayingMovieEqualTo(true).findAll();
  }

  @override
  Future<List<Movie>> getPopularMovies() {
    return _isar.movies.filter().isPopularMovieEqualTo(true).findAll();
  }

  @override
  Future<List<Movie>> getTopRatedMovies() {
    return _isar.movies.filter().isTopRatedMovieEqualTo(true).findAll();
  }

  @override
  Future<List<Movie>> getUpcomingMovies() {
    return _isar.movies.filter().isUpcomingMovieEqualTo(true).findAll();
  }
}
