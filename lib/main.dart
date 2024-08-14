import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'viewmodels/movie_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment variables
  //await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
    final viewModel = ref.read(movieViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: movieState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : movieState.error != null
              ? Center(child: Text('Error: ${movieState.error}'))
              : movieState.movies.isEmpty
                  ? const Center(child: Text('No movies found'))
                  : ListView.builder(
                      itemCount: movieState.movies.length,
                      itemBuilder: (context, index) {
                        final movie = movieState.movies[index];
                        return ListTile(
                          title: Text(movie.title),
                          subtitle: Text(
                              '${movie.voteAverage} - ${movie.releaseDate.day} - ${movie.genres}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await viewModel.deleteMovie(movie.id);
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
