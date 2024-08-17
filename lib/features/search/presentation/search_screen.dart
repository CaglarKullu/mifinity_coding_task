import 'package:flutter/material.dart';
import '../widgets/movie_search_delegate.dart';

class SearchScreen extends StatelessWidget {
  final List<String> allMovies = [
    'https://image.tmdb.org/t/p/w500/movie1.jpg',
    'https://image.tmdb.org/t/p/w500/movie2.jpg',
    'https://image.tmdb.org/t/p/w500/movie3.jpg',
    'https://image.tmdb.org/t/p/w500/movie4.jpg',
    // Add more movie URLs as needed
  ];

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(allMovies: allMovies, context),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Search for your favorite movies and shows!',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
