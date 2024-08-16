import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mifinity_coding_task/features/dashboard/widgets/fakeflix_app_bar.dart';

import '../state/movie_state.dart';
import '../state/movie_viewmodel.dart';
import '../widgets/movie_list.dart';

@RoutePage()
class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(movieViewModelProvider);
    final movieViewModel = ref.watch(movieViewModelProvider.notifier);
    return Scaffold(
      appBar: const FakeflixAppBar(),
      body: Builder(
        builder: (context) {
          switch (movieState.runtimeType) {
            case const (MovieLoadingState):
              return const Center(child: CircularProgressIndicator());
            case const (MovieErrorState):
              final errorState = movieState as MovieErrorState;
              return Center(child: Text('Error: ${errorState.message}'));
            case const (MovieLoadedState):
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                primary: true,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Popular Movies',
                          style: Theme.of(context).textTheme.bodyMedium),
                      MovieList(
                        loadMovies: movieViewModel.getTopRatedMovies,
                      ),
                      Text('Upcoming Movies',
                          style: Theme.of(context).textTheme.bodyMedium),
                      MovieList(
                        loadMovies: movieViewModel.getUpcomingMovies,
                      ),
                      Text('Now Playing Movies',
                          style: Theme.of(context).textTheme.bodyMedium),
                      MovieList(
                        loadMovies: movieViewModel.getNowPlayingMovies,
                      ),
                      Text('Top Rated Movies',
                          style: Theme.of(context).textTheme.bodyMedium),
                      MovieList(
                        loadMovies: movieViewModel.getPopularMovies,
                      ),
                    ]),
              );
            case MovieEmptyState _:
              return const Center(child: Text('No movies found'));
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
