import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/error_widget.dart';

// Provider for favorite channels
final favoriteChannelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    {'id': 1, 'name': 'Channel 1', 'iconUrl': null, 'streamUrl': 'http://stream.example.com/1'},
    {'id': 2, 'name': 'Channel 2', 'iconUrl': null, 'streamUrl': 'http://stream.example.com/2'},
    {'id': 3, 'name': 'Channel 3', 'iconUrl': null, 'streamUrl': 'http://stream.example.com/3'},
  ];
});

// Provider for favorite movies
final favoriteMoviesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    {'id': 1, 'name': 'Movie 1', 'year': '2024', 'rating': '8.5', 'posterUrl': null},
    {'id': 2, 'name': 'Movie 2', 'year': '2023', 'rating': '7.9', 'posterUrl': null},
  ];
});

// Provider for favorite series
final favoriteSeriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    {'id': 1, 'name': 'Series 1', 'year': '2024', 'rating': '9.0', 'seasons': 2},
    {'id': 2, 'name': 'Series 2', 'year': '2023', 'rating': '8.2', 'seasons': 3},
    {'id': 3, 'name': 'Series 3', 'year': '2024', 'rating': '7.5', 'seasons': 1},
  ];
});

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            'Favorites',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(icon: Icon(Icons.live_tv), text: 'Live'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
              Tab(icon: Icon(Icons.video_library), text: 'Series'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _FavoriteChannelsTab(),
            _FavoriteMoviesTab(),
            _FavoriteSeriesTab(),
          ],
        ),
      ),
    );
  }
}

class _FavoriteChannelsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteChannelsProvider);

    return favoritesAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState(
            'No favorite channels',
            'Add channels to your favorites to see them here',
            Icons.live_tv,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final channel = favorites[index];
            return _buildChannelTile(context, channel);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stack) => ErrorState(
        title: 'Error loading favorites',
        message: error.toString(),
        icon: Icons.error_outline,
        actions: [
          ElevatedButton.icon(
            onPressed: () => ref.refresh(favoriteChannelsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelTile(BuildContext context, Map<String, dynamic> channel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.live_tv, color: AppColors.primary),
      ),
      title: Text(
        channel['name'] ?? 'Unknown',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: const Text(
        'Live TV',
        style: TextStyle(color: AppColors.textTertiary),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.favorite, color: AppColors.favoriteColor),
        onPressed: () {
          // Remove from favorites
        },
      ),
      onTap: () {
        context.push(
          AppRouter.player,
          extra: {
            'streamUrl': channel['streamUrl'] ?? '',
            'title': channel['name'] ?? 'Live Channel',
            'contentType': 'live',
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.textTertiary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textTertiary.withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FavoriteMoviesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteMoviesProvider);

    return favoritesAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState(
            'No favorite movies',
            'Add movies to your favorites to see them here',
            Icons.movie,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final movie = favorites[index];
            return _buildMovieTile(context, movie);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stack) => ErrorState(
        title: 'Error loading favorites',
        message: error.toString(),
        icon: Icons.error_outline,
        actions: [
          ElevatedButton.icon(
            onPressed: () => ref.refresh(favoriteMoviesProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieTile(BuildContext context, Map<String, dynamic> movie) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        width: 56,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.movie, color: AppColors.vodColor),
      ),
      title: Text(
        movie['name'] ?? 'Unknown',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${movie['year'] ?? 'N/A'} • Rating: ${movie['rating'] ?? 'N/A'}',
        style: const TextStyle(color: AppColors.textTertiary),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.favorite, color: AppColors.favoriteColor),
        onPressed: () {
          // Remove from favorites
        },
      ),
      onTap: () {
        context.push(
          AppRouter.player,
          extra: {
            'streamUrl': 'http://stream.example.com/movie/${movie['id']}',
            'title': movie['name'] ?? 'Movie',
            'contentType': 'movie',
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.textTertiary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textTertiary.withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FavoriteSeriesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteSeriesProvider);

    return favoritesAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState(
            'No favorite series',
            'Add series to your favorites to see them here',
            Icons.video_library,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final series = favorites[index];
            return _buildSeriesTile(context, series);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stack) => ErrorState(
        title: 'Error loading favorites',
        message: error.toString(),
        icon: Icons.error_outline,
        actions: [
          ElevatedButton.icon(
            onPressed: () => ref.refresh(favoriteSeriesProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesTile(BuildContext context, Map<String, dynamic> series) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        width: 56,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.video_library, color: AppColors.seriesColor),
      ),
      title: Text(
        series['name'] ?? 'Unknown',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${series['year'] ?? 'N/A'} • ${series['seasons'] ?? 0} seasons',
        style: const TextStyle(color: AppColors.textTertiary),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.favorite, color: AppColors.favoriteColor),
        onPressed: () {
          // Remove from favorites
        },
      ),
      onTap: () {
        // Show series detail
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.textTertiary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textTertiary.withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
