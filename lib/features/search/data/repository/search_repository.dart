import 'package:isar/isar.dart';

import '../../../dashboard/models/genre.dart';
import '../../../dashboard/models/movie.dart';
import 'i_search_repository.dart';

class SearchRepository implements SearchRepositoryInterface {
  final Isar isar;

  SearchRepository(this.isar);

  @override
  Future<List<Movie>> searchMovies(String query) async {
    // Perform a search in the Isar database based on the movie title
    return await isar.movies
        .filter()
        .titleContains(query, caseSensitive: false)
        .findAll();
  }

  @override
  Future<List<Movie>> generalSearch(String query) async {
    final results = await isar.movies
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .originalTitleContains(query, caseSensitive: false)
        .or()
        .overviewContains(query, caseSensitive: false)
        .findAll();

    results.sort((a, b) {
      final aTitleMatch = a.title.toLowerCase().contains(query.toLowerCase());
      final bTitleMatch = b.title.toLowerCase().contains(query.toLowerCase());

      if (aTitleMatch && !bTitleMatch) {
        return -1;
      } else if (!aTitleMatch && bTitleMatch) {
        return 1;
      } else {
        return 0;
      }
    });

    return results;
  }

  @override
  Future<List<Movie>> searchByGenre(String genreName) async {
    return await isar.movies
        .filter()
        .genresElement((q) => q.nameContains(genreName, caseSensitive: false))
        .findAll();
  }
}
