import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/global_providers/global_providers.dart';
import '../../dashboard/models/movie.dart';
import '../data/repository/search_repository.dart';

import 'search_state.dart';

class SearchViewModel extends StateNotifier<SearchState> {
  final SearchRepository searchRepository;

  SearchViewModel(this.searchRepository) : super(SearchEmptyState());

  Future<void> searchMovies(String query) async {
    state = SearchLoadingState();

    try {
      final results = await Future.any([
        searchRepository.generalSearch(query),
        Future.delayed(const Duration(seconds: 3), () => <Movie>[])
      ]);

      if (results.isEmpty) {
        state = SearchEmptyState();
      } else {
        state = SearchLoadedState(results);
      }
    } catch (e) {
      state = SearchErrorState(_handleError(e));
    }
  }

  void clearResults() {
    state = SearchEmptyState();
  }

  AppError _handleError(dynamic error) {
    if (error is NetworkError) {
      return NetworkError(error.message);
    } else if (error is ApiError) {
      return ApiError(error.message);
    } else if (error is DatabaseError) {
      return DatabaseError(error.message);
    } else if (error is ParsingError) {
      return ParsingError(error.message);
    } else {
      return UnknownError('An unknown error occurred: $error');
    }
  }
}

final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, SearchState>((ref) {
  final searchRepository = ref.watch(searchRepositoryProvider);
  return SearchViewModel(searchRepository);
});
