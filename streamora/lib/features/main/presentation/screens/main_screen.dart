import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class MainScreen extends ConsumerStatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final _destinations = const [
    NavigationDestination(icon: Icon(Icons.live_tv), label: 'Live'),
    NavigationDestination(icon: Icon(Icons.movie), label: 'Movies'),
    NavigationDestination(icon: Icon(Icons.tv), label: 'Series'),
    NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  final _routes = const ['/', '/movies', '/series', '/favorites', '/settings'];

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update index based on current route
    final location = GoRouterState.of(context).matchedLocation;
    final index = _routes.indexOf(location);
    if (index != -1 && index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          context.go(_routes[index]);
        },
        destinations: _destinations,
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primary.withOpacity(0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
