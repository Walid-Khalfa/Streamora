import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/channel_card.dart';
import '../widgets/category_tabs.dart';

class LiveTvScreen extends StatefulWidget {
  const LiveTvScreen({super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> {
  int _selectedCategory = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Live TV'),
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
              'Sports',
              'News',
              'Entertainment',
              'Movies',
              'Kids',
              'Music',
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
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return ChannelCard(
                  name: 'Channel ${index + 1}',
                  iconUrl: null,
                  isFavorite: index % 3 == 0,
                  onTap: () {
                    // TODO: Open player
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
