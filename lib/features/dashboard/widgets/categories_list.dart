import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mifinity_coding_task/features/dashboard/widgets/movie_list.dart';

import '../state/movie_viewmodel.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieViewModel = ref.watch(movieViewModelProvider.notifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      primary: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Popular Movies', style: Theme.of(context).textTheme.bodyMedium),
        MovieList(
          loadMovies: movieViewModel.getTopRatedMovies,
        ),
        Text('Upcoming Movies', style: Theme.of(context).textTheme.bodyMedium),
        MovieList(
          loadMovies: movieViewModel.getUpcomingMovies,
        ),
        Text('Now Playing Movies',
            style: Theme.of(context).textTheme.bodyMedium),
        MovieList(
          loadMovies: movieViewModel.getNowPlayingMovies,
        ),
        Text('Top Rated Movies', style: Theme.of(context).textTheme.bodyMedium),
        MovieList(
          loadMovies: movieViewModel.getPopularMovies,
        ),
      ]),
    );
  }
}
