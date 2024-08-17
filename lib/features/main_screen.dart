import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mifinity_coding_task/features/dashboard/widgets/fakeflix_app_bar.dart';
import 'package:mifinity_coding_task/features/profile/presentation/profile.dart';
import 'package:mifinity_coding_task/features/search/presentation/search_screen.dart';

import '../core/global_providers/global_providers.dart';
import '../core/utils/utils.dart';
import 'dashboard/presentation/dashboard_screen.dart';

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
        children: [
          const Center(
            child: DashboardScreen(),
          ),
          Center(child: SearchScreen()),
          const Placeholder(),
          const Center(child: ProfileScreen()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            if (index == 2) {
              showFeatureUnavailableDialog(context, 'Download');
            } else {
              ref.read(bottomNavIndexProvider.notifier).state = index;
            }
          },
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
