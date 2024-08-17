import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

class MovieSearchDelegate extends SearchDelegate<String> {
  final List<String> allMovies;
  Timer? _debounce;
  final Duration debounceDuration;
  final BuildContext context;

  MovieSearchDelegate(this.context,
      {required this.allMovies,
      this.debounceDuration = const Duration(milliseconds: 2000)});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _debounce?.cancel(); // Cancel the debounce timer
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
        _debounce?.cancel(); // Cancel the debounce timer
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allMovies
        .where((movie) => movie.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return results.isNotEmpty
        ? LayoutBuilder(
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
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle movie selection
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: results[index],
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
          )
        : const Center(
            child: Text(
              'No results found',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _debouncedSearchResults();
  }

  Widget _debouncedSearchResults() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(debounceDuration, () {
      // The logic to execute after debounce delay
      showResults(context);
    });

    final suggestions = allMovies
        .where((movie) => movie.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
