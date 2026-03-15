import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Search results provider
final searchResultsProvider = FutureProvider.family<List<SearchResult>, String>((ref, query) async {
  if (query.isEmpty) {
    return [];
  }
  
  // Simulate API call delay
  await Future.delayed(const Duration(milliseconds: 500));
  
  // Return mock search results
  final List<SearchResult> results = [];
  
  // Add mock live channels
  for (int i = 0; i < 3; i++) {
    results.add(SearchResult(
      id: 'live_$i',
      title: '${query} Channel ${i + 1}',
      subtitle: 'Live TV • Sports',
      type: ContentType.live,
      imageUrl: null,
    ));
  }
  
  // Add mock movies
  for (int i = 0; i < 5; i++) {
    results.add(SearchResult(
      id: 'movie_$i',
      title: '${query} Movie ${i + 1}',
      subtitle: 'Movie • Action',
      type: ContentType.movie,
      imageUrl: null,
    ));
  }
  
  // Add mock series
  for (int i = 0; i < 3; i++) {
    results.add(SearchResult(
      id: 'series_$i',
      title: '${query} Series ${i + 1}',
      subtitle: 'Series • Drama',
      type: ContentType.series,
      imageUrl: null,
    ));
  }
  
  return results;
});

enum ContentType { live, movie, series }

class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final ContentType type;
  final String? imageUrl;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.imageUrl,
  });
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider(query));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Search channels, movies, series...',
            hintStyle: TextStyle(color: AppColors.textTertiary.withOpacity(0.6)),
            border: InputBorder.none,
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.textTertiary),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  )
                : null,
          ),
          onChanged: _performSearch,
          onSubmitted: (value) {
            // Search is already being performed on change
          },
        ),
      ),
      body: _buildBody(query, resultsAsync),
    );
  }

  Widget _buildBody(String query, AsyncValue<List<SearchResult>> resultsAsync) {
    if (query.isEmpty) {
      return _buildSuggestions();
    }

    return resultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return _buildNoResults(query);
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: results.length,
          separatorBuilder: (context, index) => Divider(
            color: AppColors.backgroundLighter,
            height: 1,
            indent: 72,
          ),
          itemBuilder: (context, index) {
            final result = results[index];
            return _buildResultTile(result);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              'Search failed',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(searchResultsProvider(query)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    final recentSearches = ref.watch(recentSearchesProvider);
    final popularCategories = ['Live TV', 'Movies', 'Sports', 'News', 'Comedy'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (recentSearches.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // Clear recent searches
                  },
                  child: const Text('Clear All'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (recentSearches.isEmpty)
            Text(
              'No recent searches',
              style: TextStyle(
                color: AppColors.textTertiary.withOpacity(0.6),
                fontSize: 14,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((search) {
                return ActionChip(
                  backgroundColor: AppColors.surface,
                  side: BorderSide.none,
                  avatar: const Icon(
                    Icons.history,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                  label: Text(
                    search,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  onPressed: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 32),

          // Popular categories
          const Text(
            'Popular Categories',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildCategoryCard('Live TV', Icons.live_tv, AppColors.liveColor),
              _buildCategoryCard('Movies', Icons.movie, AppColors.vodColor),
              _buildCategoryCard('Series', Icons.video_library, AppColors.seriesColor),
              _buildCategoryCard('Sports', Icons.sports, AppColors.accent),
            ],
          ),
          const SizedBox(height: 32),

          // Trending
          const Text(
            'Trending Now',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.play_circle_outline,
                  color: AppColors.textTertiary,
                ),
              ),
              title: Text(
                'Trending Item ${index + 1}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Category • ${(index + 1) * 124}K views',
                style: TextStyle(
                  color: AppColors.textTertiary.withOpacity(0.8),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textTertiary,
                size: 16,
              ),
              onTap: () {
                // Navigate to content
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultTile(SearchResult result) {
    IconData icon;
    Color iconColor;

    switch (result.type) {
      case ContentType.live:
        icon = Icons.live_tv;
        iconColor = AppColors.liveColor;
      case ContentType.movie:
        icon = Icons.movie;
        iconColor = AppColors.vodColor;
      case ContentType.series:
        icon = Icons.video_library;
        iconColor = AppColors.seriesColor;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        result.title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        result.subtitle,
        style: TextStyle(
          color: AppColors.textTertiary.withOpacity(0.8),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textTertiary,
        size: 16,
      ),
      onTap: () => _openContent(result),
    );
  }

  Widget _buildNoResults(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: AppColors.textTertiary.withOpacity(0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No results for "$query"',
            style: TextStyle(
              color: AppColors.textTertiary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _searchController.text = title;
          _performSearch(title);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openContent(SearchResult result) {
    // Navigate to player with mock stream URL
    context.push(
      AppRouter.player,
      extra: {
        'streamUrl': 'http://stream.example.com/${result.type}/${result.id}',
        'title': result.title,
        'iconUrl': result.imageUrl,
        'contentType': result.type.name,
        'contentId': result.id,
      },
    );
  }
}

// Provider for recent searches
final recentSearchesProvider = StateProvider<List<String>>((ref) {
  return [
    'Action movies',
    'Sports channels',
    'News',
    'Comedy series',
  ];
});
