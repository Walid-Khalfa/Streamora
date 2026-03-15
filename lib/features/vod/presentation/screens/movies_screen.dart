import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../live/domain/entities/category.dart';
import '../../domain/entities/movie.dart';
import '../../data/datasources/vod_remote_datasource.dart';
import '../widgets/movie_card.dart';
import '../../../live/presentation/widgets/category_tabs.dart';

// Provider for VOD Remote Data Source
final vodRemoteDataSourceProvider = Provider<VodRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VodRemoteDataSourceImpl(apiClient);
});

// Provider for movies - uses real API when authenticated
final moviesProvider = FutureProvider.family<List<Movie>, int>((ref, categoryId) async {
  final authState = ref.watch(authProvider);
  
  // Check if user is authenticated
  if (authState.user == null || !authState.isAuthenticated) {
    return _getMockMovies(categoryId);
  }
  
  final user = authState.user!;
  final dataSource = ref.watch(vodRemoteDataSourceProvider);
  
  try {
    final movies = await dataSource.getMovies(
      baseUrl: user.baseUrl,
      username: user.username,
      password: user.password,
      categoryId: categoryId == 0 ? null : categoryId,
    );
    return movies;
  } catch (e) {
    // Fall back to mock data on error
    return _getMockMovies(categoryId);
  }
});

// Helper function to generate mock movies
List<Movie> _getMockMovies(int categoryId) {
  // Simulate network delay
  return List.generate(30, (index) {
    final categories = ['Action', 'Comedy', 'Drama', 'Horror', 'Sci-Fi', 'Documentary'];
    return Movie(
      id: index,
      name: 'Movie ${index + 1}',
      streamUrl: 'http://stream.example.com/movie/$index',
      categoryId: categoryId,
      categoryName: categories[index % categories.length],
      rating: '${(index % 5) + 5}.${index % 10}',
      year: '202${index % 4}',
      posterUrl: null,
    );
  });
}

// Provider for movie categories - uses real API when authenticated
final movieCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final authState = ref.watch(authProvider);
  
  // Check if user is authenticated
  if (authState.user == null || !authState.isAuthenticated) {
    return _getMockCategories();
  }
  
  final user = authState.user!;
  final dataSource = ref.watch(vodRemoteDataSourceProvider);
  
  try {
    final categories = await dataSource.getCategories(
      baseUrl: user.baseUrl,
      username: user.username,
      password: user.password,
    );
    return ['All', ...categories.map((c) => c.name).toList()];
  } catch (e) {
    // Fall back to mock categories on error
    return _getMockCategories();
  }
});

// Helper function to generate mock categories
List<String> _getMockCategories() {
  return [
    'All',
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
    'Documentary',
  ];
}

class MoviesScreen extends ConsumerStatefulWidget {
  const MoviesScreen({super.key});

  @override
  ConsumerState<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends ConsumerState<MoviesScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(movieCategoriesProvider);
    final moviesAsync = ref.watch(moviesProvider(_selectedCategory));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Movies',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () => context.push(AppRouter.search),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: AppColors.textPrimary),
            onPressed: () => _showSortDialog(),
            tooltip: 'Sort',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Categories
          categoriesAsync.when(
            data: (categories) => CategoryTabs(
              categories: categories,
              selectedIndex: _selectedCategory,
              onCategorySelected: (index) {
                setState(() => _selectedCategory = index);
              },
            ),
            loading: () => const SizedBox(
              height: 50,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            error: (error, stack) => const SizedBox.shrink(),
          ),
          
          // Movies Grid
          Expanded(
            child: moviesAsync.when(
              data: (movies) {
                if (movies.isEmpty) {
                  return EmptyState(
                    title: 'No Movies',
                    subtitle: 'No movies found in this category',
                    icon: Icons.movie_outlined,
                    action: TextButton.icon(
                      onPressed: () => ref.refresh(moviesProvider(_selectedCategory)),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(moviesProvider(_selectedCategory));
                  },
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          _openPlayer(
                            streamUrl: movie.streamUrl,
                            title: movie.name,
                            posterUrl: movie.posterUrl,
                          );
                        },
                        onFavoriteToggle: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Added to favorites'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => _buildLoadingGrid(),
              error: (error, stack) => ErrorState(
                title: 'Failed to Load Movies',
                message: error.toString(),
                icon: Icons.movie_outlined,
                iconColor: AppColors.error,
                actions: [
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(moviesProvider(_selectedCategory)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLighter,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLighter,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLighter,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openPlayer({required String streamUrl, required String title, String? posterUrl}) {
    context.push(
      AppRouter.player,
      extra: {
        'streamUrl': streamUrl,
        'title': title,
        'iconUrl': posterUrl,
        'contentType': 'movie',
      },
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort Movies',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _buildSortOption('Name (A-Z)', true),
            _buildSortOption('Name (Z-A)', false),
            _buildSortOption('Year (Newest)', false),
            _buildSortOption('Year (Oldest)', false),
            _buildSortOption('Rating (Highest)', false),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, bool isSelected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.circle_outlined, color: AppColors.textTertiary),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
