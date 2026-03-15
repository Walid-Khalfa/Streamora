import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/channel_card.dart';
import '../widgets/category_tabs.dart';

// Provider for live channels - would normally fetch from API
final liveChannelsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, categoryId) async {
  // Simulate API call delay
  await Future.delayed(const Duration(milliseconds: 800));
  
  // Return mock data
  return List.generate(20, (index) => {
    'id': index,
    'name': 'Channel ${index + 1}',
    'iconUrl': null,
    'isFavorite': index % 3 == 0,
    'streamUrl': 'http://stream.example.com/live/$index',
  });
});

// Provider for categories
final liveCategoriesProvider = FutureProvider<List<String>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    'All',
    'Sports',
    'News',
    'Entertainment',
    'Movies',
    'Kids',
    'Music',
  ];
});

class LiveTvScreen extends ConsumerStatefulWidget {
  const LiveTvScreen({super.key});

  @override
  ConsumerState<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends ConsumerState<LiveTvScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(liveCategoriesProvider);
    final channelsAsync = ref.watch(liveChannelsProvider(_selectedCategory));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Live TV',
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
          
          // Channels Grid
          Expanded(
            child: channelsAsync.when(
              data: (channels) {
                if (channels.isEmpty) {
                  return EmptyState(
                    title: 'No Channels',
                    subtitle: 'No channels found in this category',
                    icon: Icons.live_tv_outlined,
                    action: TextButton.icon(
                      onPressed: () => ref.refresh(liveChannelsProvider(_selectedCategory)),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(liveChannelsProvider(_selectedCategory));
                  },
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: channels.length,
                    itemBuilder: (context, index) {
                      final channel = channels[index];
                      return ChannelCard(
                        name: channel['name'] ?? 'Unknown',
                        iconUrl: channel['iconUrl'],
                        isFavorite: channel['isFavorite'] ?? false,
                        onTap: () {
                          _openPlayer(
                            streamUrl: channel['streamUrl'] ?? '',
                            title: channel['name'] ?? 'Live Channel',
                          );
                        },
                        onFavoriteToggle: () {
                          // TODO: Toggle favorite
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                channel['isFavorite'] 
                                  ? 'Removed from favorites' 
                                  : 'Added to favorites'
                              ),
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
                title: 'Failed to Load Channels',
                message: error.toString(),
                icon: Icons.error_outline,
                iconColor: AppColors.error,
                actions: [
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(liveChannelsProvider(_selectedCategory)),
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
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.backgroundLighter,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.live_tv,
                    color: AppColors.textTertiary,
                    size: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLighter,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
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

  void _openPlayer({required String streamUrl, required String title}) {
    context.push(
      AppRouter.player,
      extra: {
        'streamUrl': streamUrl,
        'title': title,
        'contentType': 'live',
      },
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
              'Filter Channels',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _buildFilterOption('All Channels', true),
            _buildFilterOption('Favorites Only', false),
            _buildFilterOption('Recently Watched', false),
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
        // TODO: Implement filter
        Navigator.pop(context);
      },
    );
  }
}
