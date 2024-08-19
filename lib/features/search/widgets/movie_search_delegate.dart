import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../dashboard/models/movie.dart';
import '../state/search_state.dart';
import '../state/search_view_model.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  final WidgetRef ref;
  Timer? _debounce;
  final Duration debounceDuration;

  MovieSearchDelegate(
      {required this.ref,
      this.debounceDuration = const Duration(milliseconds: 2000)});

  @override
  String get searchFieldLabel => 'Search titles, plots, genre...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _debounce?.cancel();
          ref.read(searchViewModelProvider.notifier).clearResults();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
        _debounce?.cancel();
        ref.read(searchViewModelProvider.notifier).clearResults();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _debounce?.cancel();
    _debounce = Timer(debounceDuration, () {
      ref.read(searchViewModelProvider.notifier).searchMovies(query);
    });

    final searchState = ref.watch(searchViewModelProvider);

    return switch (searchState) {
      SearchLoadingState() => const Center(child: CircularProgressIndicator()),
      SearchErrorState(:var error) => Center(
          child: Text(
            error.message,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      SearchEmptyState() => const Center(
          child: Text(
            'No results found',
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ),
      SearchLoadedState(:var movies) => _buildMovieGrid(movies),
      _ => const Center(child: Text('Search for your favorite movies!')),
    };
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    if (query.isNotEmpty) {
      _debounce = Timer(debounceDuration, () async {
        // Trigger the search after the debounce period
        await ref.read(searchViewModelProvider.notifier).searchMovies(query);
        showResults(context);
      });
    }

    final searchState = ref.watch(searchViewModelProvider);

    return switch (searchState) {
      SearchLoadedState(:var movies) => _buildSuggestionList(movies),
      _ => Center(
          child: Text(
            query.isEmpty ? 'Search for your favorite movies!' : 'Searching...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ),
    };
  }

  Widget _buildSuggestionList(List<Movie> suggestions) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final movie = suggestions[index];
        return ListTile(
          leading: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w200${movie.posterPath}',
            width: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          title: Text(movie.title),
          subtitle: Text(movie.voteAverage.toString()),
          onTap: () {
            query = movie.title;
            showResults(context);
          },
        );
      },
    );
  }

  Widget _buildMovieGrid(List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          double width = constraints.maxWidth;

          if (width > 1200) {
            crossAxisCount = 6;
          } else if (width > 800) {
            crossAxisCount = 4;
          } else if (width > 600) {
            crossAxisCount = 3;
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 2 / 3.5,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  close(context, movie);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
