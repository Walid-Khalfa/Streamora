import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/vod_provider.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailsProvider(movieId));

    return Scaffold(
      body: movieAsync.when(
        data: (movie) => CustomScrollView(
          slivers: [
            // App Bar with backdrop
            SliverAppBar(
              expandedHeight: 250.h,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: movie.backdropUrl != null
                    ? Image.network(
                        movie.backdropUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                      )
                    : movie.coverUrl != null
                        ? Image.network(
                            movie.coverUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                          )
                        : _buildPlaceholder(context),
              ),
            ),
            // Movie Details
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      movie.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Meta info row
                    Wrap(
                      spacing: 12.w,
                      children: [
                        if (movie.releaseDate != null)
                          _buildMetaChip(movie.releaseDate!),
                        if (movie.duration != null)
                          _buildMetaChip(movie.duration!),
                        if (movie.rating != null)
                          _buildRatingChip(movie.rating!),
                        if (movie.genre != null)
                          _buildMetaChip(movie.genre!),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    // Play Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton.icon(
                        onPressed: () => _playMovie(context, movie),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play Movie'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Favorite Button
                    SizedBox(
                      width: double.infinity,
                      height: 45.h,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Toggle favorite
                        },
                        icon: Icon(
                          movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: movie.isFavorite ? AppColors.liveRed : null,
                        ),
                        label: Text(
                          movie.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Plot
                    if (movie.plot != null) ...[
                      Text(
                        'Synopsis',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        movie.plot!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondaryDark,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                    // Cast
                    if (movie.cast != null) ...[
                      Text(
                        'Cast',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        movie.cast!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                    // Director
                    if (movie.director != null) ...[
                      Text(
                        'Director',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        movie.director!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: LoadingWidget()),
        error: (error, _) => ErrorDisplay(
          message: 'Failed to load movie details',
          onRetry: () => ref.invalidate(movieDetailsProvider(movieId)),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: AppColors.surfaceDark,
      child: Center(
        child: Icon(
          Icons.movie,
          size: 64.w,
          color: AppColors.gray600,
        ),
      ),
    );
  }

  Widget _buildMetaChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.textSecondaryDark,
        ),
      ),
    );
  }

  Widget _buildRatingChip(String rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 14.w,
            color: AppColors.warning,
          ),
          SizedBox(width: 4.w),
          Text(
            rating,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _playMovie(BuildContext context, movie) {
    context.push('/player', extra: {
      'streamUrl': movie.streamUrl,
      'title': movie.name,
      'type': 'vod',
      'streamId': movie.id,
      'coverUrl': movie.coverUrl ?? movie.backdropUrl,
      'position': movie.progress,
    });
  }
}
