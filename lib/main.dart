import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/global_providers/global_providers.dart';
import 'routes/app_router.dart';

void main() async {
  // Ensure WidgetsBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment variables from the .env file
  await dotenv.load(fileName: ".env"); // Load the .env file

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Movie Database',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router.config(),
    );
  }
}
