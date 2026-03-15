import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 32.w,
        height: size ?? 32.h,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LoadingWidget(size: 48),
                  if (message != null) ...[
                    SizedBox(height: 16.h),
                    Text(
                      message!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray800,
      highlightColor: AppColors.gray700,
      child: child,
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const SkeletonCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 120.h,
        decoration: BoxDecoration(
          color: AppColors.gray800,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double? size;

  const SkeletonCircle({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: size ?? 48.w,
        height: size ?? 48.h,
        decoration: const BoxDecoration(
          color: AppColors.gray800,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double? width;
  final double? height;

  const SkeletonText({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 16.h,
        decoration: BoxDecoration(
          color: AppColors.gray800,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}
