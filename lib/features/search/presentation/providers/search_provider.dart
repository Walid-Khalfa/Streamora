import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchState {
  final String query;
  final List<SearchResult> results;
  final bool isLoading;
  final String? errorMessage;
  final List<String> recentSearches;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.errorMessage,
    this.recentSearches = const [],
  });

  SearchState copyWith({
    String? query,
    List<SearchResult>? results,
    bool? isLoading,
    String? errorMessage,
    List<String>? recentSearches,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

class SearchResult {
  final int id;
  final String title;
  final String type; // 'live', 'movie', 'series'
  final String? iconUrl;
  final String? category;
  final Map<String, dynamic>? metadata;

  SearchResult({
    required this.id,
    required this.title,
    required this.type,
    this.iconUrl,
    this.category,
    this.metadata,
  });
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(query: '', results: []);
      return;
    }

    state = state.copyWith(
      query: query,
      isLoading: true,
      errorMessage: null,
    );

    try {
      // TODO: Implement actual search
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock results
      final results = <SearchResult>[
        SearchResult(
          id: 1,
          title: '$query - Live Channel',
          type: 'live',
          category: 'Sports',
        ),
        SearchResult(
          id: 2,
          title: '$query - Movie',
          type: 'movie',
          category: 'Action',
          metadata: {'year': '2023', 'rating': '8.5'},
        ),
        SearchResult(
          id: 3,
          title: '$query - Series',
          type: 'series',
          category: 'Drama',
          metadata: {'seasons': 3},
        ),
      ];

      // Add to recent searches
      final updatedRecent = [query, ...state.recentSearches.where((s) => s != query)];
      final trimmedRecent = updatedRecent.take(10).toList();

      state = state.copyWith(
        results: results,
        isLoading: false,
        recentSearches: trimmedRecent,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearSearch() {
    state = state.copyWith(
      query: '',
      results: [],
      errorMessage: null,
    );
  }

  void removeRecentSearch(String search) {
    state = state.copyWith(
      recentSearches: state.recentSearches.where((s) => s != search).toList(),
    );
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});
