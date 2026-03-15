import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Channels', icon: Icon(Icons.live_tv)),
              Tab(text: 'Movies', icon: Icon(Icons.movie)),
              Tab(text: 'Series', icon: Icon(Icons.tv)),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondaryDark,
            indicatorColor: AppColors.primary,
          ),
        ),
        body: const TabBarView(
          children: [
            _FavoritesList(type: 'live'),
            _FavoritesList(type: 'movie'),
            _FavoritesList(type: 'series'),
          ],
        ),
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  final String type;
  const _FavoritesList({required this.type});

  @override
  Widget build(BuildContext context) {
    // Placeholder - would connect to favorites provider
    return const EmptyState(
      message: 'No favorites yet. Tap the heart icon on any item to add it here.',
      icon: Icons.favorite_border,
    );
  }
}
