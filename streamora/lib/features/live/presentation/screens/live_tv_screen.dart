import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/live_provider.dart';
import '../widgets/channel_card.dart';
import '../widgets/category_tabs.dart';

class LiveTvScreen extends ConsumerStatefulWidget {
  const LiveTvScreen({super.key});

  @override
  ConsumerState<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends ConsumerState<LiveTvScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(liveNotifierProvider.notifier).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final liveState = ref.watch(liveNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live TV'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(liveNotifierProvider.notifier).loadCategories();
            },
          ),
        ],
      ),
      body: liveState.when(
        initial: () => const Center(child: LoadingWidget()),
        loading: () => const Center(child: LoadingWidget()),
        loaded: (categories, channels, selectedCategory, filteredChannels, searchQuery) {
          return Column(
            children: [
              // Category Tabs
              CategoryTabs(
                categories: categories,
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  ref.read(liveNotifierProvider.notifier).selectCategory(category);
                },
              ),
              // Channel Grid
              Expanded(
                child: filteredChannels.isEmpty
                    ? const EmptyState(
                        message: 'No channels found in this category',
                        icon: Icons.tv_off,
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                        ),
                        itemCount: filteredChannels.length,
                        itemBuilder: (context, index) {
                          final channel = filteredChannels[index];
                          return ChannelCard(
                            channel: channel,
                            onTap: () => _onChannelTap(channel),
                            onEpgTap: () => _onEpgTap(channel),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        error: (message) => ErrorDisplay(
          message: message,
          onRetry: () => ref.read(liveNotifierProvider.notifier).loadCategories(),
        ),
      ),
    );
  }

  void _onChannelTap(channel) {
    context.push('/player', extra: {
      'streamUrl': channel.streamUrl,
      'title': channel.name,
      'type': 'live',
      'streamId': channel.id,
      'coverUrl': channel.iconUrl,
    });
  }

  void _onEpgTap(channel) {
    context.push('/epg/${channel.id}', extra: {
      'channelName': channel.name,
      'channelLogo': channel.iconUrl,
    });
  }
}
