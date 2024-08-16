import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieList extends StatefulWidget {
  final List<String> initialMoviePosters;
  final Future<List<String>> Function() loadMoreMovies;

  const MovieList({
    super.key,
    required this.initialMoviePosters,
    required this.loadMoreMovies,
  });

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late List<String> _moviePosters;
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _moviePosters = List.from(widget.initialMoviePosters);
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
      List<String> newMovies = await widget.loadMoreMovies();
      setState(() {
        _moviePosters.addAll(newMovies);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double imageWidth = screenWidth / 3.5;
    double height = imageWidth * 1.5;

    return SizedBox(
      height: height + 16,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _moviePosters.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _moviePosters.length) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Handle movie poster tap
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/w500${_moviePosters[index]}',
                  fit: BoxFit.fitWidth,
                  width: imageWidth,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
