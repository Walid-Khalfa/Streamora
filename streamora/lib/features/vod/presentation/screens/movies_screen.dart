import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../live/presentation/widgets/category_tabs.dart';
import '../providers/vod_provider.dart';
import '../widgets/movie_card.dart';

class MoviesScreen extends ConsumerStatefulWidget {
  const MoviesScreen({super.key});

  @override
  ConsumerState<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends ConsumerState<MoviesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(vodNotifierProvider.notifier).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vodState = ref.watch(vodNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(vodNotifierProvider.notifier).loadCategories();
            },
          ),
        ],
      ),
      body: vodState.when(
        initial: () => const Center(child: LoadingWidget()),
        loading: () => const Center(child: LoadingWidget()),
        loaded: (categories, movies, selectedCategory, filteredMovies, searchQuery) {
          return Column(
            children: [
              // Category Tabs
              CategoryTabs(
                categories: categories,
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  ref.read(vodNotifierProvider.notifier).selectCategory(category);
                },
              ),
              // Movie Grid
              Expanded(
                child: filteredMovies.isEmpty
                    ? const EmptyState(
                        message: 'No movies found in this category',
                        icon: Icons.movie_outlined,
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                        ),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = filteredMovies[index];
                          return MovieCard(
                            movie: movie,
                            onTap: () => context.push('/movie/${movie.id}'),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        error: (message) => ErrorDisplay(
          message: message,
          onRetry: () => ref.read(vodNotifierProvider.notifier).loadCategories(),
        ),
      ),
    );
  }
}
