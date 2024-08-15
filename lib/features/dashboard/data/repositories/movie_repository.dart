import 'package:isar/isar.dart';
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
  Future<void> deleteMovie(int id) async {
    await _isar!.writeTxn(() async {
      await _isar!.movies.delete(id);
    });
  }
}
