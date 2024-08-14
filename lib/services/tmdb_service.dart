import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/genre.dart';
import '../utils/app_error.dart';

class TMDbService {
  final String apiKey;
  final String apiUrl = 'https://api.themoviedb.org/3';
  late Map<int, String> genreMap;

  TMDbService(this.apiKey);

  // Fetch genres and populate the genre map
  Future<void> fetchGenres() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/genre/movie/list?api_key=$apiKey'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List genres = data['genres'];

        genreMap = {for (var genre in genres) genre['id']: genre['name']};
      } else {
        throw ApiError('Failed to load genres from the API');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw NetworkError(
            'Network error occurred while fetching genres: ${e.message}');
      } else {
        throw ApiError(
            'API error occurred while fetching genres: ${e.toString()}');
      }
    }
  }

  Future<List<Movie>> fetchPopularMovies() async {
    await fetchGenres(); // Ensure genres are fetched before fetching movies

    try {
      final response =
          await http.get(Uri.parse('$apiUrl/movie/popular?api_key=$apiKey'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List movies = data['results'];

        try {
          return movies.map((movie) {
            return Movie()
              ..tmdbId = movie['id']
              ..title = movie['title']
              ..originalTitle = movie['original_title']
              ..overview = movie['overview']
              ..releaseDate = DateTime.parse(movie['release_date'])
              ..voteAverage = movie['vote_average'].toDouble()
              ..voteCount = movie['vote_count']
              ..posterPath = movie['poster_path'] ?? ''
              ..backdropPath = movie['backdrop_path'] ?? ''
              ..originalLanguage = movie['original_language']
              ..adult = movie['adult']
              ..status = 'Released'
              ..tagline = ''
              ..budget = 0
              ..revenue = 0
              ..runtime = 0
              ..homepage = ''
              ..imdbId = ''
              ..video = movie['video']
              ..popularity = movie['popularity'].toDouble()
              ..genres = (movie['genre_ids'] as List<dynamic>)
                  .map((genreId) => Genre()
                    ..id = genreId
                    ..name = genreMap[genreId] ?? 'Unknown')
                  .toList();
          }).toList();
        } catch (e) {
          throw ParsingError(
              'Parsing error occurred while processing movies: ${e.toString()}');
        }
      } else {
        throw ApiError('Failed to load popular movies from the API');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw NetworkError(
            'Network error occurred while fetching movies: ${e.message}');
      } else if (e is ParsingError) {
        rethrow; // Re-throw the parsing error to be handled by the caller
      } else {
        throw ApiError(
            'API error occurred while fetching movies: ${e.toString()}');
      }
    }
  }
}
