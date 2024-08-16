import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/movie.dart';

class MovieList extends StatefulWidget {
  final Future<List<Movie>> Function() loadMovies;

  const MovieList({
    super.key,
    required this.loadMovies,
  });

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late Future<List<Movie>> _moviesFuture;
  late ScrollController _scrollController;
  bool _isLoading = false;
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _moviesFuture = widget.loadMovies();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      List<Movie> newMovies = await widget.loadMovies();
      setState(() {
        _movies.addAll(newMovies);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double imageWidth = screenWidth / 3.5;
    double height = imageWidth * 1.5;

    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading movies'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No movies available'));
        } else {
          _movies = snapshot.data!;
          return SizedBox(
            height: height + 16,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _movies.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _movies.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle movie poster tap, e.g., navigate to details
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${_movies[index].posterPath}',
                        fit: BoxFit.fitWidth,
                        width: imageWidth,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator.adaptive()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
