import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mifinity_coding_task/routes/app_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/models/user.dart';
import '../../features/dashboard/data/repositories/movie_repository.dart';
import '../../features/dashboard/models/movie.dart';

final routerProvider = Provider<AppRouter>(AppRouter.new);

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([MovieSchema, UserSchema], directory: dir.path);
  return isar;
});

final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return AuthRepository(isar);
});

final movieRepositoryProvider = FutureProvider<MovieRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return MovieRepository(isar);
});
