import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/genre.dart';
import '../models/movie.dart';

class TMDbService {
  final String apiKey;
  final String apiUrl = 'https://api.themoviedb.org/3';
  late Map<int, String> genreMap; // Map to store genre IDs and names

  TMDbService(this.apiKey);

  // Fetch genres and populate the genre map
  Future<void> fetchGenres() async {
    final response =
        await http.get(Uri.parse('$apiUrl/genre/movie/list?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List genres = data['genres'];

      genreMap = {for (var genre in genres) genre['id']: genre['name']};
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<Movie>> fetchPopularMovies() async {
    // Ensure genres are fetched before fetching movies
    await fetchGenres();

    final response =
        await http.get(Uri.parse('$apiUrl/movie/popular?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List movies = data['results'];

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
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}
