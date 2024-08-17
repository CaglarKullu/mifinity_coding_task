import '../../models/movie.dart';

abstract class MovieRepositoryInterface {
  Future<void> init();
  Future<void> addMovie(Movie movie);

  Future<List<Movie>> getMovies();
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> getUpcomingMovies();
  Future<List<Movie>> searchByGenre(String genreName);
  Future<List<Movie>> generalSearch(String query);

  Future<void> deleteMovie(int id);
}
