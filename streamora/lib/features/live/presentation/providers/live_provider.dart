import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/live_remote_datasource.dart';
import '../../domain/entities/epg_program.dart';
import '../../domain/entities/live_channel.dart';

part 'live_provider.freezed.dart';
part 'live_provider.g.dart';

@freezed
class LiveState with _$LiveState {
  const factory LiveState.initial() = _Initial;
  const factory LiveState.loading() = _Loading;
  const factory LiveState.loaded({
    required List<Category> categories,
    required List<LiveChannel> channels,
    Category? selectedCategory,
    @Default([]) List<LiveChannel> filteredChannels,
    String? searchQuery,
  }) = _Loaded;
  const factory LiveState.error(String message) = _Error;
}

@Riverpod(keepAlive: true)
class LiveNotifier extends _$LiveNotifier {
  @override
  LiveState build() {
    return const LiveState.initial();
  }

  Future<void> loadCategories() async {
    state = const LiveState.loading();
    
    final dataSource = ref.read(liveRemoteDataSourceProvider);
    try {
      final categories = await dataSource.getLiveCategories();
      // Add "All" category
      final allCategories = [
        const Category(id: 0, name: 'All'),
        ...categories,
      ];
      
      // Load all channels initially
      final channels = await dataSource.getLiveStreams();
      
      state = LiveState.loaded(
        categories: allCategories,
        channels: channels,
        selectedCategory: allCategories.first,
        filteredChannels: channels,
      );
    } catch (e) {
      state = LiveState.error('Failed to load categories: $e');
    }
  }

  Future<void> selectCategory(Category category) async {
    state.whenOrNull(
      loaded: (categories, channels, _, __, searchQuery) async {
        state = LiveState.loading();
        
        try {
          List<LiveChannel> filteredChannels;
          if (category.id == 0) {
            filteredChannels = channels;
          } else {
            final dataSource = ref.read(liveRemoteDataSourceProvider);
            filteredChannels = await dataSource.getLiveStreams(categoryId: category.id);
          }

          // Apply search if exists
          if (searchQuery != null && searchQuery.isNotEmpty) {
            filteredChannels = filteredChannels
                .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
          }

          state = LiveState.loaded(
            categories: categories,
            channels: channels,
            selectedCategory: category,
            filteredChannels: filteredChannels,
            searchQuery: searchQuery,
          );
        } catch (e) {
          state = LiveState.error('Failed to load channels: $e');
        }
      },
    );
  }

  void search(String query) {
    state.whenOrNull(
      loaded: (categories, channels, selectedCategory, _, __) {
        final filteredChannels = query.isEmpty
            ? channels
            : channels
                .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
                .toList();

        state = LiveState.loaded(
          categories: categories,
          channels: channels,
          selectedCategory: selectedCategory,
          filteredChannels: filteredChannels,
          searchQuery: query,
        );
      },
    );
  }
}

// EPG Provider
@riverpod
class EpgNotifier extends _$EpgNotifier {
  @override
  Future<List<EpgProgram>> build(int channelId) async {
    final dataSource = ref.read(liveRemoteDataSourceProvider);
    return await dataSource.getShortEpgForChannel(channelId, limit: 10);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final dataSource = ref.read(liveRemoteDataSourceProvider);
    try {
      final programs = await dataSource.getShortEpgForChannel(
        (state.value?.first.channelId ?? 0),
        limit: 10,
      );
      state = AsyncData(programs);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
