import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/live_channel.dart';

class ChannelCard extends StatelessWidget {
  final LiveChannel channel;
  final VoidCallback onTap;
  final VoidCallback? onEpgTap;

  const ChannelCard({
    super.key,
    required this.channel,
    required this.onTap,
    this.onEpgTap,
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
            // Channel Logo / Placeholder
            Expanded(
              child: Container(
                color: AppColors.surfaceDark,
                child: channel.iconUrl != null
                    ? Image.network(
                        channel.iconUrl!,
                        fit: BoxFit.contain,
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
            ),
            // Channel Info
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                children: [
                  // Live indicator
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: AppColors.liveRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Channel Name
                  Expanded(
                    child: Text(
                      channel.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // EPG Button
                  if (onEpgTap != null)
                    InkWell(
                      onTap: onEpgTap,
                      child: Icon(
                        Icons.event_note,
                        size: 18.w,
                        color: AppColors.textTertiaryDark,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder({Widget? child}) {
    return Center(
      child: child ??
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.live_tv,
                size: 32.w,
                color: AppColors.gray600,
              ),
              SizedBox(height: 4.h),
              Text(
                channel.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
    );
  }
}

class ChannelListTile extends StatelessWidget {
  final LiveChannel channel;
  final VoidCallback onTap;
  final String? currentProgram;

  const ChannelListTile({
    super.key,
    required this.channel,
    required this.onTap,
    this.currentProgram,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: channel.iconUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  channel.iconUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                ),
              )
            : _buildPlaceholder(),
      ),
      title: Text(
        channel.name,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: currentProgram != null
          ? Text(
              currentProgram!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondaryDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Container(
        width: 8.w,
        height: 8.h,
        decoration: const BoxDecoration(
          color: AppColors.liveRed,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Text(
        channel.name.substring(0, 1).toUpperCase(),
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.gray600,
        ),
      ),
    );
  }
}
