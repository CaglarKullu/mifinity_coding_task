import 'package:mifinity_coding_task/features/dashboard/models/genre.dart';

import '../../../dashboard/models/movie.dart';

abstract class SearchRepositoryInterface {
  Future<List<Movie>> searchMovies(String query);
  Future<List<Movie>> generalSearch(String query);
  Future<List<Movie>> searchByGenre(String genreName);
}
