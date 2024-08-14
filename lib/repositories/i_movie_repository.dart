import '../models/movie.dart';

abstract class MovieRepositoryInterface {
  Future<void> init();

  Future<void> addMovie(Movie movie);

  Future<List<Movie>> getMovies();

  Future<void> deleteMovie(int id);
}
