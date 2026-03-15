import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../live/presentation/providers/live_provider.dart';
import '../../../vod/presentation/providers/vod_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search channels, movies, series...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColors.textTertiaryDark),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
          style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 16.sp),
          onChanged: (value) => setState(() => _query = value),
        ),
      ),
      body: _query.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64.w, color: AppColors.gray600),
                  SizedBox(height: 16.h),
                  Text('Start typing to search', style: TextStyle(color: AppColors.textSecondaryDark)),
                ],
              ),
            )
          : _SearchResults(query: _query),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  final String query;
  const _SearchResults({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveState = ref.watch(liveNotifierProvider);
    final vodState = ref.watch(vodNotifierProvider);

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // Live Channels
        if (liveState is _Loaded) ...[
          Text('Live Channels', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          ...liveState.channels
              .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
              .take(5)
              .map((channel) => ListTile(
                    leading: channel.iconUrl != null
                        ? Image.network(channel.iconUrl!, width: 40.w, height: 40.h, errorBuilder: (_, __, ___) => const Icon(Icons.live_tv))
                        : const Icon(Icons.live_tv),
                    title: Text(channel.name),
                    trailing: const Icon(Icons.play_arrow, color: AppColors.primary),
                    onTap: () => context.push('/player', extra: {'streamUrl': channel.streamUrl, 'title': channel.name, 'type': 'live', 'streamId': channel.id}),
                  )),
          const Divider(),
        ],
        // Movies
        if (vodState is _Loaded) ...[
          SizedBox(height: 16.h),
          Text('Movies', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          ...vodState.movies
              .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
              .take(5)
              .map((movie) => ListTile(
                    leading: movie.coverUrl != null
                        ? Image.network(movie.coverUrl!, width: 40.w, height: 60.h, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.movie))
                        : const Icon(Icons.movie),
                    title: Text(movie.name),
                    subtitle: movie.genre != null ? Text(movie.genre!) : null,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/movie/${movie.id}'),
                  )),
        ],
      ],
    );
  }
}
