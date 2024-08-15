import 'package:isar/isar.dart';
import 'package:mifinity_coding_task/features/dashboard/models/genre.dart';

part 'movie.g.dart';

@Collection()
class Movie {
  Id id = Isar.autoIncrement; // Auto-incremented id for local storage

  @Index(unique: true, replace: true)
  late int tmdbId; // TMDb ID
  late String title;
  late String originalTitle;
  late String overview;
  late DateTime releaseDate;
  late double voteAverage;
  late int voteCount;
  late String posterPath;
  late String backdropPath;
  late String originalLanguage;
  late bool adult;
  late String status;
  late String tagline;
  late int budget;
  late int revenue;
  late int runtime;
  late String homepage;
  late String imdbId;
  late bool video;
  late double popularity;

  List<Genre> genres = [];
  List<String> spokenLanguages = [];
  List<String> productionCompanies = [];
  List<String> productionCountries = [];
}
