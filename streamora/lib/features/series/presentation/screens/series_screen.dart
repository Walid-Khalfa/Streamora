import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../live/presentation/widgets/category_tabs.dart';
import '../providers/series_provider.dart';
import '../widgets/series_card.dart';

class SeriesScreen extends ConsumerStatefulWidget {
  const SeriesScreen({super.key});

  @override
  ConsumerState<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends ConsumerState<SeriesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(seriesNotifierProvider.notifier).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final seriesState = ref.watch(seriesNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => context.push('/search')),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(seriesNotifierProvider.notifier).loadCategories()),
        ],
      ),
      body: seriesState.when(
        initial: () => const Center(child: LoadingWidget()),
        loading: () => const Center(child: LoadingWidget()),
        loaded: (categories, series, selectedCategory, filteredSeries, searchQuery) => Column(
          children: [
            CategoryTabs(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) => ref.read(seriesNotifierProvider.notifier).selectCategory(category),
            ),
            Expanded(
              child: filteredSeries.isEmpty
                  ? const EmptyState(message: 'No series found in this category', icon: Icons.tv_off)
                  : GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                      ),
                      itemCount: filteredSeries.length,
                      itemBuilder: (context, index) => SeriesCard(
                        series: filteredSeries[index],
                        onTap: () => context.push('/series/${filteredSeries[index].id}'),
                      ),
                    ),
            ),
          ],
        ),
        error: (message) => ErrorDisplay(message: message, onRetry: () => ref.read(seriesNotifierProvider.notifier).loadCategories()),
      ),
    );
  }
}
