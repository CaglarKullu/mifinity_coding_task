import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TMDbService {
  final String apiKey;
  final String apiUrl = 'https://api.themoviedb.org/3/movie/popular';

  TMDbService(this.apiKey);

  Future<List<Movie>> fetchPopularMovies() async {
    final response = await http.get(Uri.parse('$apiUrl?api_key=$apiKey'));

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
          ..status =
              'Released' // Default value, not provided by the popular API
          ..tagline = '' // Default value, not provided by the popular API
          ..budget = 0 // Default value, not provided by the popular API
          ..revenue = 0 // Default value, not provided by the popular API
          ..runtime = 0 // Default value, not provided by the popular API
          ..homepage = '' // Default value, not provided by the popular API
          ..imdbId = '' // Default value, not provided by the popular API
          ..video = movie['video']
          ..popularity = movie['popularity'].toDouble()
          ..genres = (movie['genre_ids'] as List<dynamic>)
              .map((genre) => genre.toString())
              .toList();
      }).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}
