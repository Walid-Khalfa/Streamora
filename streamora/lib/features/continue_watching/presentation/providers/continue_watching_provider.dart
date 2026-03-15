import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/watch_progress.dart';

part 'continue_watching_provider.freezed.dart';
part 'continue_watching_provider.g.dart';

@freezed
class ContinueWatchingState with _$ContinueWatchingState {
  const factory ContinueWatchingState.initial() = _Initial;
  const factory ContinueWatchingState.loading() = _Loading;
  const factory ContinueWatchingState.loaded(List<WatchProgress> items) = _Loaded;
  const factory ContinueWatchingState.error(String message) = _Error;
}

@Riverpod(keepAlive: true)
class ContinueWatchingNotifier extends _$ContinueWatchingNotifier {
  final List<WatchProgress> _watchHistory = [];

  @override
  ContinueWatchingState build() {
    return const ContinueWatchingState.initial();
  }

  Future<void> loadHistory() async {
    state = const ContinueWatchingState.loading();
    // In a real app, load from local database
    state = ContinueWatchingState.loaded(_watchHistory.where((item) => item.shouldContinue).toList());
  }

  void updateProgress({
    required int contentId,
    required String contentType,
    required String title,
    required String streamUrl,
    String? coverUrl,
    required int position,
    required int duration,
    required double progress,
  }) {
    final existingIndex = _watchHistory.indexWhere((item) => item.contentId == contentId && item.contentType == contentType);

    final watchProgress = WatchProgress(
      id: existingIndex >= 0 ? _watchHistory[existingIndex].id : const Uuid().v4(),
      contentId: contentId,
      contentType: contentType,
      title: title,
      coverUrl: coverUrl,
      streamUrl: streamUrl,
      position: position,
      duration: duration,
      progress: progress,
      lastWatched: DateTime.now(),
    );

    if (existingIndex >= 0) {
      _watchHistory[existingIndex] = watchProgress;
    } else {
      _watchHistory.add(watchProgress);
    }

    // Sort by last watched
    _watchHistory.sort((a, b) => b.lastWatched.compareTo(a.lastWatched));

    state = ContinueWatchingState.loaded(_watchHistory.where((item) => item.shouldContinue).toList());
  }

  void removeItem(String id) {
    _watchHistory.removeWhere((item) => item.id == id);
    state = ContinueWatchingState.loaded(_watchHistory.where((item) => item.shouldContinue).toList());
  }

  void clearHistory() {
    _watchHistory.clear();
    state = const ContinueWatchingState.loaded([]);
  }
}
