import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mifinity_coding_task/features/dashboard/widgets/fakeflix_app_bar.dart';

import '../core/global_providers/global_providers.dart';
import 'dashboard/presentation/dashboard_view.dart';

@RoutePage()
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);
    return SafeArea(
        child: Scaffold(
      appBar: const FakeflixAppBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          Center(
            child: DashboardView(),
          ),
          Center(child: Text('Search')),
          Center(child: Text('Download')),
          Center(child: Text('Profile')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) =>
              ref.read(bottomNavIndexProvider.notifier).state = index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.movie), label: 'Movie List'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.download), label: 'Download'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    ));
  }
}
