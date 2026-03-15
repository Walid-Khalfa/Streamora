import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/series.dart';
import '../widgets/series_card.dart';
import '../../../live/presentation/widgets/category_tabs.dart';

// Provider for series
final seriesProvider = FutureProvider.family<List<Series>, int>((ref, categoryId) async {
  await Future.delayed(const Duration(milliseconds: 800));
  
  return List.generate(20, (index) {
    final categories = ['Drama', 'Comedy', 'Action', 'Crime', 'Sci-Fi', 'Thriller'];
    return Series(
      id: index,
      name: 'Series ${index + 1}',
      categoryId: categoryId,
      categoryName: categories[index % categories.length],
      rating: '${(index % 5) + 5}.${index % 10}',
      year: '202${index % 4}',
      seasons: List.generate(
        (index % 5) + 1,
        (s) => Season(
          seasonNumber: s + 1,
          name: 'Season ${s + 1}',
          episodes: const [],
        ),
      ),
    );
  });
});

// Provider for series categories
final seriesCategoriesProvider = FutureProvider<List<String>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    'All',
    'Drama',
    'Comedy',
    'Action',
    'Crime',
    'Sci-Fi',
    'Thriller',
  ];
});

class SeriesScreen extends ConsumerStatefulWidget {
  const SeriesScreen({super.key});

  @override
  ConsumerState<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends ConsumerState<SeriesScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(seriesCategoriesProvider);
    final seriesAsync = ref.watch(seriesProvider(_selectedCategory));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'TV Series',
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
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
            onPressed: () => _showFilterDialog(),
            tooltip: 'Filter',
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
          
          // Series Grid
          Expanded(
            child: seriesAsync.when(
              data: (seriesList) {
                if (seriesList.isEmpty) {
                  return EmptyState(
                    title: 'No Series',
                    subtitle: 'No series found in this category',
                    icon: Icons.video_library_outlined,
                    action: TextButton.icon(
                      onPressed: () => ref.refresh(seriesProvider(_selectedCategory)),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(seriesProvider(_selectedCategory));
                  },
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: seriesList.length,
                    itemBuilder: (context, index) {
                      final series = seriesList[index];
                      return SeriesCard(
                        series: series,
                        onTap: () {
                          _showSeriesDetail(series);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => _buildLoadingGrid(),
              error: (error, stack) => ErrorState(
                title: 'Failed to Load Series',
                message: error.toString(),
                icon: Icons.video_library_outlined,
                iconColor: AppColors.error,
                actions: [
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(seriesProvider(_selectedCategory)),
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
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
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
                padding: const EdgeInsets.all(12),
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
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 60,
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

  void _showSeriesDetail(Series series) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    series.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          series.categoryName,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        series.year ?? 'N/A',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            series.rating ?? 'N/A',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Seasons',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: series.seasons.length,
                      itemBuilder: (context, index) {
                        final season = series.seasons[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLighter,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'S${season.seasonNumber}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            season.name,
                            style: const TextStyle(color: AppColors.textPrimary),
                          ),
                          subtitle: Text(
                            '${season.episodes.length} episodes',
                            style: TextStyle(color: AppColors.textTertiary),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textTertiary,
                            size: 16,
                          ),
                          onTap: () {
                            // TODO: Open season episodes
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
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
              'Filter Series',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _buildFilterOption('All Series', true),
            _buildFilterOption('Recently Added', false),
            _buildFilterOption('Most Popular', false),
            _buildFilterOption('Top Rated', false),
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
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
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
