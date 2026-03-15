import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/series.dart';
import '../providers/series_provider.dart';

class SeriesDetailScreen extends ConsumerWidget {
  final int seriesId;
  const SeriesDetailScreen({super.key, required this.seriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesDetailsProvider(seriesId));
    return seriesAsync.when(
      data: (series) => DefaultTabController(
        length: series.seasons.length,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 250.h,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(series.name, style: TextStyle(fontSize: 16.sp)),
                  background: series.backdropUrl != null
                      ? Image.network(series.backdropUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder())
                      : series.coverUrl != null
                          ? Image.network(series.coverUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder())
                          : _buildPlaceholder(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(series.name, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      if (series.genre != null)
                        Text(series.genre!, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondaryDark)),
                      SizedBox(height: 8.h),
                      if (series.rating != null)
                        Row(
                          children: [
                            Icon(Icons.star, size: 16.w, color: AppColors.warning),
                            SizedBox(width: 4.w),
                            Text(series.rating!, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      SizedBox(height: 16.h),
                      if (series.plot != null)
                        Text(series.plot!, style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryDark, height: 1.5)),
                      SizedBox(height: 16.h),
                      if (series.cast != null) ...[
                        Text('Cast', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                        SizedBox(height: 4.h),
                        Text(series.cast!, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondaryDark)),
                      ],
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
              if (series.seasons.isNotEmpty)
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      isScrollable: true,
                      tabs: series.seasons.map((s) => Tab(text: 'Season ${s.seasonNumber}')).toList(),
                    ),
                  ),
                  pinned: true,
                ),
            ],
            body: series.seasons.isEmpty
                ? const Center(child: Text('No episodes available'))
                : TabBarView(
                    children: series.seasons.map((season) => _buildEpisodesList(context, season)).toList(),
                  ),
          ),
        ),
      ),
      loading: () => const Scaffold(body: Center(child: LoadingWidget())),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorDisplay(message: 'Failed to load series details', onRetry: () => ref.invalidate(seriesDetailsProvider(seriesId))),
      ),
    );
  }

  Widget _buildPlaceholder() => Container(color: AppColors.surfaceDark, child: Center(child: Icon(Icons.tv, size: 64.w, color: AppColors.gray600)));

  Widget _buildEpisodesList(BuildContext context, Season season) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: season.episodes.length,
      itemBuilder: (context, index) {
        final episode = season.episodes[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            contentPadding: EdgeInsets.all(12.w),
            leading: episode.coverUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(episode.coverUrl!, width: 100.w, height: 60.h, fit: BoxFit.cover),
                  )
                : Container(width: 100.w, height: 60.h, decoration: BoxDecoration(color: AppColors.surfaceDark, borderRadius: BorderRadius.circular(8.r)), child: Icon(Icons.play_circle, color: AppColors.gray600)),
            title: Text('E${episode.episodeNumber}: ${episode.title}', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (episode.duration != null) Text(episode.duration!, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondaryDark)),
                if (episode.progress != null && episode.progress! > 0) ...[
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(value: episode.progress, backgroundColor: AppColors.gray700, minHeight: 3.h),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow, color: AppColors.primary),
              onPressed: () => context.push('/player', extra: {
                'streamUrl': episode.streamUrl,
                'title': episode.title,
                'type': 'series',
                'streamId': episode.id,
                'coverUrl': episode.coverUrl,
                'position': episode.progress,
              }),
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override double get minExtent => _tabBar.preferredSize.height;
  @override double get maxExtent => _tabBar.preferredSize.height;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Container(color: Theme.of(context).scaffoldBackgroundColor, child: _tabBar);
  @override bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) => false;
}
