import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/continue_watching_provider.dart';

class ContinueWatchingScreen extends ConsumerWidget {
  const ContinueWatchingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(continueWatchingNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Continue Watching')),
      body: state.when(
        initial: () => const Center(child: LoadingWidget()),
        loading: () => const Center(child: LoadingWidget()),
        loaded: (items) => items.isEmpty
            ? const EmptyState(message: 'No items in continue watching', icon: Icons.history)
            : ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.w),
                      leading: item.coverUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(item.coverUrl!, width: 80.w, height: 60.h, fit: BoxFit.cover),
                            )
                          : Container(width: 80.w, height: 60.h, decoration: BoxDecoration(color: AppColors.surfaceDark, borderRadius: BorderRadius.circular(8.r)), child: Icon(Icons.play_circle, color: AppColors.gray600)),
                      title: Text(item.title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item.contentType.toUpperCase()} • ${Duration(seconds: item.position).toFormattedDuration} left', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondaryDark)),
                          SizedBox(height: 8.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2.r),
                            child: LinearProgressIndicator(value: item.progress, backgroundColor: AppColors.gray700, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 3.h),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textTertiaryDark),
                        onPressed: () => ref.read(continueWatchingNotifierProvider.notifier).removeItem(item.id),
                      ),
                      onTap: () => context.push('/player', extra: {'streamUrl': item.streamUrl, 'title': item.title, 'type': item.contentType, 'streamId': item.contentId, 'coverUrl': item.coverUrl, 'position': item.progress}),
                    ),
                  );
                },
              ),
        error: (message) => ErrorDisplay(message: message, onRetry: () => ref.read(continueWatchingNotifierProvider.notifier).loadHistory()),
      ),
    );
  }
}
