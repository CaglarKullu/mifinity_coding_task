// lib/app_router.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.gr.dart' as router;

@AutoRouterConfig(
  replaceInRouteName: 'Screen,Route',
)
class AppRouter extends router.$AppRouter {
  final Ref ref;
  AppRouter(this.ref);
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: router.AuthRoute.page, initial: true),
        AutoRoute(page: router.MainRoute.page),
      ];
}
