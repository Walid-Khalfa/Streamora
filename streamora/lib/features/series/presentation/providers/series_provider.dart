import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../live/domain/entities/live_channel.dart';
import '../../data/datasources/series_remote_datasource.dart';
import '../../domain/entities/series.dart';

part 'series_provider.freezed.dart';
part 'series_provider.g.dart';

@freezed
class SeriesState with _$SeriesState {
  const factory SeriesState.initial() = _Initial;
  const factory SeriesState.loading() = _Loading;
  const factory SeriesState.loaded({
    required List<Category> categories,
    required List<Series> series,
    Category? selectedCategory,
    @Default([]) List<Series> filteredSeries,
    String? searchQuery,
  }) = _Loaded;
  const factory SeriesState.error(String message) = _Error;
}

@Riverpod(keepAlive: true)
class SeriesNotifier extends _$SeriesNotifier {
  @override
  SeriesState build() => const SeriesState.initial();

  Future<void> loadCategories() async {
    state = const SeriesState.loading();
    final dataSource = ref.read(seriesRemoteDataSourceProvider);
    try {
      final categories = await dataSource.getSeriesCategories();
      final allCategories = [const Category(id: 0, name: 'All'), ...categories];
      final series = await dataSource.getSeries();
      state = SeriesState.loaded(
        categories: allCategories,
        series: series,
        selectedCategory: allCategories.first,
        filteredSeries: series,
      );
    } catch (e) {
      state = SeriesState.error('Failed to load categories: $e');
    }
  }

  Future<void> selectCategory(Category category) async {
    state.whenOrNull(
      loaded: (categories, series, _, __, searchQuery) async {
        state = const SeriesState.loading();
        try {
          List<Series> filtered;
          if (category.id == 0) {
            filtered = series;
          } else {
            final dataSource = ref.read(seriesRemoteDataSourceProvider);
            filtered = await dataSource.getSeries(categoryId: category.id);
          }
          if (searchQuery != null && searchQuery.isNotEmpty) {
            filtered = filtered.where((s) => s.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
          }
          state = SeriesState.loaded(
            categories: categories,
            series: series,
            selectedCategory: category,
            filteredSeries: filtered,
            searchQuery: searchQuery,
          );
        } catch (e) {
          state = SeriesState.error('Failed to load series: $e');
        }
      },
    );
  }

  void search(String query) {
    state.whenOrNull(
      loaded: (categories, series, selectedCategory, _, __) {
        final filtered = query.isEmpty
            ? series
            : series.where((s) => s.name.toLowerCase().contains(query.toLowerCase())).toList();
        state = SeriesState.loaded(
          categories: categories,
          series: series,
          selectedCategory: selectedCategory,
          filteredSeries: filtered,
          searchQuery: query,
        );
      },
    );
  }
}

@riverpod
Future<Series> seriesDetails(Ref ref, int seriesId) async {
  final dataSource = ref.read(seriesRemoteDataSourceProvider);
  return await dataSource.getSeriesInfo(seriesId);
}
