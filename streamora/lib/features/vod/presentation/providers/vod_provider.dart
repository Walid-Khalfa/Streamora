import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../live/domain/entities/live_channel.dart';
import '../../data/datasources/vod_remote_datasource.dart';
import '../../domain/entities/movie.dart';

part 'vod_provider.freezed.dart';
part 'vod_provider.g.dart';

@freezed
class VodState with _$VodState {
  const factory VodState.initial() = _Initial;
  const factory VodState.loading() = _Loading;
  const factory VodState.loaded({
    required List<Category> categories,
    required List<Movie> movies,
    Category? selectedCategory,
    @Default([]) List<Movie> filteredMovies,
    String? searchQuery,
  }) = _Loaded;
  const factory VodState.error(String message) = _Error;
}

@Riverpod(keepAlive: true)
class VodNotifier extends _$VodNotifier {
  @override
  VodState build() {
    return const VodState.initial();
  }

  Future<void> loadCategories() async {
    state = const VodState.loading();

    final dataSource = ref.read(vodRemoteDataSourceProvider);
    try {
      final categories = await dataSource.getVodCategories();
      final allCategories = [
        const Category(id: 0, name: 'All'),
        ...categories,
      ];

      final movies = await dataSource.getVodStreams();

      state = VodState.loaded(
        categories: allCategories,
        movies: movies,
        selectedCategory: allCategories.first,
        filteredMovies: movies,
      );
    } catch (e) {
      state = VodState.error('Failed to load categories: $e');
    }
  }

  Future<void> selectCategory(Category category) async {
    state.whenOrNull(
      loaded: (categories, movies, _, __, searchQuery) async {
        state = const VodState.loading();

        try {
          List<Movie> filteredMovies;
          if (category.id == 0) {
            filteredMovies = movies;
          } else {
            final dataSource = ref.read(vodRemoteDataSourceProvider);
            filteredMovies = await dataSource.getVodStreams(categoryId: category.id);
          }

          if (searchQuery != null && searchQuery.isNotEmpty) {
            filteredMovies = filteredMovies
                .where((m) => m.name.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
          }

          state = VodState.loaded(
            categories: categories,
            movies: movies,
            selectedCategory: category,
            filteredMovies: filteredMovies,
            searchQuery: searchQuery,
          );
        } catch (e) {
          state = VodState.error('Failed to load movies: $e');
        }
      },
    );
  }

  void search(String query) {
    state.whenOrNull(
      loaded: (categories, movies, selectedCategory, _, __) {
        final filteredMovies = query.isEmpty
            ? movies
            : movies
                .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
                .toList();

        state = VodState.loaded(
          categories: categories,
          movies: movies,
          selectedCategory: selectedCategory,
          filteredMovies: filteredMovies,
          searchQuery: query,
        );
      },
    );
  }
}

// Movie details provider
@riverpod
Future<Movie> movieDetails(Ref ref, int movieId) async {
  final dataSource = ref.read(vodRemoteDataSourceProvider);
  return await dataSource.getVodDetails(movieId);
}
