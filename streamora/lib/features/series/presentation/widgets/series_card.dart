import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/series.dart';

class SeriesCard extends StatelessWidget {
  final Series series;
  final VoidCallback onTap;

  const SeriesCard({super.key, required this.series, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: series.coverUrl != null
                  ? Image.network(series.coverUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder(), loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildPlaceholder(child: Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null, strokeWidth: 2, color: AppColors.primary)));
                    })
                  : _buildPlaceholder(),
            ),
            Container(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(series.name, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (series.totalEpisodes > 0)
                        Text('${series.totalEpisodes} episodes', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondaryDark)),
                      if (series.seasons.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        Text('${series.seasons.length} seasons', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondaryDark)),
                      ],
                    ],
                  ),
                  if (series.progress != null && series.progress! > 0) ...[
                    SizedBox(height: 8.h),
                    LinearProgressIndicator(value: series.progress, backgroundColor: AppColors.gray700, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 3.h),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder({Widget? child}) => Container(color: AppColors.surfaceDark, child: child ?? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.tv, size: 40.w, color: AppColors.gray600), SizedBox(height: 8.h), Text(series.name.substring(0, 1).toUpperCase(), style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: AppColors.gray600))])));
}
