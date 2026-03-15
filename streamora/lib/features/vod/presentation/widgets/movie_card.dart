import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Movie Poster
            Expanded(
              child: movie.coverUrl != null
                  ? Image.network(
                      movie.coverUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildPlaceholder(
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    )
                  : _buildPlaceholder(),
            ),
            // Movie Info
            Container(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (movie.rating != null) ...[
                        Icon(
                          Icons.star,
                          size: 14.w,
                          color: AppColors.warning,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          movie.rating!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      if (movie.duration != null)
                        Text(
                          movie.duration!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textTertiaryDark,
                          ),
                        ),
                    ],
                  ),
                  // Progress indicator for continue watching
                  if (movie.progress != null && movie.progress! > 0) ...[
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.r),
                      child: LinearProgressIndicator(
                        value: movie.progress,
                        backgroundColor: AppColors.gray700,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 3.h,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder({Widget? child}) {
    return Container(
      color: AppColors.surfaceDark,
      child: child ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie,
                  size: 40.w,
                  color: AppColors.gray600,
                ),
                SizedBox(height: 8.h),
                Text(
                  movie.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class MovieListTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieListTile({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 60.w,
        height: 90.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: movie.coverUrl != null
            ? Image.network(
                movie.coverUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
      title: Text(
        movie.name,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (movie.duration != null)
            Text(
              movie.duration!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondaryDark,
              ),
            ),
          if (movie.progress != null && movie.progress! > 0) ...[
            SizedBox(height: 4.h),
            LinearProgressIndicator(
              value: movie.progress,
              backgroundColor: AppColors.gray700,
              minHeight: 2.h,
            ),
          ],
        ],
      ),
      trailing: movie.isFavorite
          ? Icon(
              Icons.favorite,
              color: AppColors.liveRed,
              size: 20.w,
            )
          : null,
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Text(
        movie.name.substring(0, 1).toUpperCase(),
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.gray600,
        ),
      ),
    );
  }
}
