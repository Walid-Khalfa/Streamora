import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie.dart';
import '../widgets/movie_card.dart';
import '../../../live/presentation/widgets/category_tabs.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Show sort options
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
              'Action',
              'Comedy',
              'Drama',
              'Horror',
              'Sci-Fi',
              'Documentary',
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
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                return MovieCard(
                  movie: Movie(
                    id: index,
                    name: 'Movie ${index + 1}',
                    streamUrl: '',
                    categoryId: 1,
                    categoryName: 'Movies',
                    rating: '${(index % 5) + 5}.0',
                    year: '202${index % 4}',
                  ),
                  onTap: () {
                    // TODO: Open movie detail
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
