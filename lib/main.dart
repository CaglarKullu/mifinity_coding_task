import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/state/movie_viewmodel.dart';
import 'features/dashboard/state/movie_state.dart';

void main() async {
  // Ensure WidgetsBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment variables from the .env file
  await dotenv.load(fileName: ".env"); // Load the .env file

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Database',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MovieListPage(),
    );
  }
}

class MovieListPage extends ConsumerWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(movieViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: Builder(
        builder: (context) {
          switch (movieState.runtimeType) {
            case const (MovieLoadingState):
              return const Center(child: CircularProgressIndicator());
            case const (MovieErrorState):
              final errorState = movieState as MovieErrorState;
              return Center(child: Text('Error: ${errorState.message}'));
            case const (MovieLoadedState):
              final loadedState = movieState as MovieLoadedState;
              return ListView.builder(
                itemCount: loadedState.movies.length,
                itemBuilder: (context, index) {
                  final movie = loadedState.movies[index];
                  return ListTile(
                    title: Text(movie.title),
                    subtitle: Text(
                        'Director: ${movie.budget} - Release Year: ${movie.genres.toString()}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final viewModel =
                            ref.read(movieViewModelProvider.notifier);
                        await viewModel.deleteMovie(movie.id);
                      },
                    ),
                  );
                },
              );
            case MovieEmptyState _:
              return const Center(child: Text('No movies found'));
            default:
              return const SizedBox.shrink(); // Fallback for unhandled cases
          }
        },
      ),
    );
  }
}
