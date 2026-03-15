import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/epg_program.dart';

class EpgTimeline extends StatelessWidget {
  final List<EpgProgram> programs;

  const EpgTimeline({
    super.key,
    required this.programs,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: programs.length,
      itemBuilder: (context, index) {
        final program = programs[index];
        final isCurrent = program.isPlayingNow;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isCurrent ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12.r),
            border: isCurrent
                ? Border.all(color: AppColors.primary.withOpacity(0.3))
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time and Duration
              Row(
                children: [
                  Text(
                    '${program.startTime.toEpgTime} - ${program.endTime.toEpgTime}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isCurrent ? AppColors.primary : AppColors.textSecondaryDark,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (isCurrent) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.liveRed,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    program.duration.toShortDuration,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiaryDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Title
              Text(
                program.title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              if (program.description != null && program.description!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  program.description!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondaryDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              // Progress bar for current program
              if (isCurrent) ...[
                SizedBox(height: 12.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: program.progressPercentage,
                    backgroundColor: AppColors.gray700,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 4.h,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${program.timeElapsed.toShortDuration} elapsed',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textTertiaryDark,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class CompactEpgWidget extends StatelessWidget {
  final List<EpgProgram> programs;
  final VoidCallback? onTap;

  const CompactEpgWidget({
    super.key,
    required this.programs,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentProgram = programs.firstWhere(
      (p) => p.isPlayingNow,
      orElse: () => programs.first,
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: AppColors.liveRed,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Now Playing',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.liveRed,
                  ),
                ),
                const Spacer(),
                Text(
                  currentProgram.endTime.toEpgTime,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textTertiaryDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              currentProgram.title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(2.r),
              child: LinearProgressIndicator(
                value: currentProgram.progressPercentage,
                backgroundColor: AppColors.gray700,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 3.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
