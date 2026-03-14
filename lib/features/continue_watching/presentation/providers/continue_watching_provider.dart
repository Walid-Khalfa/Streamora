import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/watch_progress.dart';

class ContinueWatchingState {
  final List<WatchProgress> items;
  final bool isLoading;
  final String? errorMessage;

  const ContinueWatchingState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ContinueWatchingState copyWith({
    List<WatchProgress>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ContinueWatchingState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<WatchProgress> get inProgressItems =>
      items.where((item) => item.isInProgress).toList();

  List<WatchProgress> get completedItems =>
      items.where((item) => item.isCompleted).toList();
}

class ContinueWatchingNotifier extends StateNotifier<ContinueWatchingState> {
  ContinueWatchingNotifier() : super(const ContinueWatchingState());

  Future<void> loadWatchHistory() async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: Load from local database
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock data
      final items = <WatchProgress>[
        WatchProgress(
          id: '1',
          contentId: 123,
          contentType: 'movie',
          title: 'The Dark Knight',
          iconUrl: null,
          duration: 9120,
          position: 3450,
          lastWatched: DateTime.now().subtract(const Duration(hours: 2)),
          category: 'Action',
        ),
        WatchProgress(
          id: '2',
          contentId: 456,
          contentType: 'episode',
          title: 'Breaking Bad - S01E01',
          iconUrl: null,
          duration: 2880,
          position: 1200,
          lastWatched: DateTime.now().subtract(const Duration(days: 1)),
          category: 'Drama',
        ),
      ];

      state = state.copyWith(
        items: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateProgress(WatchProgress progress) async {
    try {
      // TODO: Save to local database
      
      final updatedItems = [...state.items];
      final index = updatedItems.indexWhere((item) => item.id == progress.id);
      
      if (index >= 0) {
        updatedItems[index] = progress;
      } else {
        updatedItems.insert(0, progress);
      }

      state = state.copyWith(items: updatedItems);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> removeItem(String id) async {
    try {
      // TODO: Delete from local database
      
      final updatedItems = state.items.where((item) => item.id != id).toList();
      state = state.copyWith(items: updatedItems);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> clearHistory() async {
    try {
      // TODO: Clear local database
      state = state.copyWith(items: []);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final continueWatchingProvider =
    StateNotifierProvider<ContinueWatchingNotifier, ContinueWatchingState>((ref) {
  return ContinueWatchingNotifier();
});
