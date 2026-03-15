import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/live_provider.dart';
import '../widgets/epg_timeline.dart';

class EpgScreen extends ConsumerWidget {
  final int channelId;
  final String channelName;
  final String? channelLogo;

  const EpgScreen({
    super.key,
    required this.channelId,
    required this.channelName,
    this.channelLogo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final epgAsync = ref.watch(epgNotifierProvider(channelId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(channelName),
            Text(
              'TV Guide',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondaryDark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(epgNotifierProvider(channelId));
            },
          ),
        ],
      ),
      body: epgAsync.when(
        data: (programs) {
          if (programs.isEmpty) {
            return EmptyState(
              title: 'No EPG Available',
              message: 'There is no program guide available for this channel.',
              icon: Icons.event_busy,
              onAction: () => ref.invalidate(epgNotifierProvider(channelId)),
              actionLabel: 'Refresh',
            );
          }

          return Column(
            children: [
              // Channel Header
              if (channelLogo != null)
                Container(
                  padding: EdgeInsets.all(16.w),
                  child: Image.network(
                    channelLogo!,
                    height: 60.h,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              
              // EPG Timeline
              Expanded(
                child: EpgTimeline(programs: programs),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, _) => ErrorDisplay(
          message: 'Failed to load EPG: $error',
          onRetry: () => ref.invalidate(epgNotifierProvider(channelId)),
        ),
      ),
    );
  }
}
