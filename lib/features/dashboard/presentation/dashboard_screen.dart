import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/movie_state.dart';
import '../state/movie_viewmodel.dart';
import '../widgets/categories_list.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(movieViewModelProvider);
    return Builder(
      builder: (context) {
        switch (movieState.runtimeType) {
          case const (MovieLoadingState):
            return const Center(child: CircularProgressIndicator());
          case const (MovieErrorState):
            final errorState = movieState as MovieErrorState;
            return Center(
                child: Text('Error: ${errorState.message.toString()}'));
          case const (MovieLoadedState):
            return const CategoriesList();
          case const (MovieEmptyState):
            return const Center(child: Text('No movies found'));
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
