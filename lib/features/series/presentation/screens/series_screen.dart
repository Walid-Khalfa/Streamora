import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/series.dart';
import '../widgets/series_card.dart';
import '../../../live/presentation/widgets/category_tabs.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('TV Series'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          CategoryTabs(
            categories: const [
              'All',
              'Drama',
              'Comedy',
              'Action',
              'Crime',
              'Sci-Fi',
              'Thriller',
            ],
            selectedIndex: _selectedCategory,
            onCategorySelected: (index) {
              setState(() => _selectedCategory = index);
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return SeriesCard(
                  series: Series(
                    id: index,
                    name: 'Series ${index + 1}',
                    categoryId: 1,
                    categoryName: 'Drama',
                    rating: '${(index % 5) + 5}.0',
                    year: '202${index % 4}',
                    seasons: List.generate(
                      (index % 5) + 1,
                      (s) => Season(
                        seasonNumber: s + 1,
                        name: 'Season ${s + 1}',
                        episodes: const [],
                      ),
                    ),
                  ),
                  onTap: () {
                    // TODO: Open series detail
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
