import 'package:isar/isar.dart';
import 'package:mifinity_coding_task/features/dashboard/models/genre.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/movie.dart';
import 'i_movie_repository.dart';

class MovieRepository implements MovieRepositoryInterface {
  Isar? _isar;

  @override
  Future<void> init() async {
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([MovieSchema], directory: dir.path);
    }
  }

  @override
  Future<void> addMovie(Movie movie) async {
    await _isar!.writeTxn(() async {
      await _isar!.movies.put(movie);
    });
  }

  @override
  Future<List<Movie>> getMovies() async {
    return await _isar!.movies.where().findAll();
  }

  @override
  Future<List<Movie>> searchByGenre(String genreName) async {
    return await _isar!.movies
        .filter()
        .genresElement((q) => q.nameContains(genreName))
        .findAll();
  }

  @override
  Future<void> deleteMovie(int id) async {
    await _isar!.writeTxn(() async {
      await _isar!.movies.delete(id);
    });
  }

  @override
  Future<List<Movie>> generalSearch(String query) async {
    return await _isar!.movies
        .filter()
        .titleContains(query)
        .or()
        .originalTitleContains(query)
        .or()
        .overviewContains(query)
        .findAll();
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() {
    return _isar!.movies.filter().isNowPlayingMovieEqualTo(true).findAll();
  }

  @override
  Future<List<Movie>> getPopularMovies() {
    return _isar!.movies.filter().isPopularMovieEqualTo(true).findAll();
  }

  @override
  Future<List<Movie>> getTopRatedMovies() {
    return _isar!.movies.filter().isTopRatedMovieEqualTo(true).findAll();
  }

  @override
  Future<List<Movie>> getUpcomingMovies() {
    return _isar!.movies.filter().isUpcomingMovieEqualTo(true).findAll();
  }
}
