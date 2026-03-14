import 'package:equatable/equatable.dart';

class Series extends Equatable {
  final int id;
  final String name;
  final String? iconUrl;
  final String? posterUrl;
  final String? backdropUrl;
  final int categoryId;
  final String categoryName;
  final String? rating;
  final String? year;
  final String? plot;
  final String? cast;
  final String? director;
  final String? genre;
  final bool isFavorite;
  final DateTime? added;
  final List<Season> seasons;

  const Series({
    required this.id,
    required this.name,
    this.iconUrl,
    this.posterUrl,
    this.backdropUrl,
    required this.categoryId,
    required this.categoryName,
    this.rating,
    this.year,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.isFavorite = false,
    this.added,
    this.seasons = const [],
  });

  Series copyWith({
    int? id,
    String? name,
    String? iconUrl,
    String? posterUrl,
    String? backdropUrl,
    int? categoryId,
    String? categoryName,
    String? rating,
    String? year,
    String? plot,
    String? cast,
    String? director,
    String? genre,
    bool? isFavorite,
    DateTime? added,
    List<Season>? seasons,
  }) {
    return Series(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      rating: rating ?? this.rating,
      year: year ?? this.year,
      plot: plot ?? this.plot,
      cast: cast ?? this.cast,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      isFavorite: isFavorite ?? this.isFavorite,
      added: added ?? this.added,
      seasons: seasons ?? this.seasons,
    );
  }

  int get totalEpisodes => seasons.fold(0, (sum, season) => sum + season.episodes.length);

  @override
  List<Object?> get props => [
        id,
        name,
        iconUrl,
        categoryId,
        categoryName,
        isFavorite,
        seasons,
      ];
}

class Season extends Equatable {
  final int seasonNumber;
  final String name;
  final List<Episode> episodes;

  const Season({
    required this.seasonNumber,
    required this.name,
    this.episodes = const [],
  });

  @override
  List<Object?> get props => [seasonNumber, name, episodes];
}

class Episode extends Equatable {
  final int id;
  final int episodeNumber;
  final String title;
  final String streamUrl;
  final String? iconUrl;
  final String? info;
  final int? duration;
  final DateTime? releaseDate;
  final bool isWatched;
  final int? watchProgress;

  const Episode({
    required this.id,
    required this.episodeNumber,
    required this.title,
    required this.streamUrl,
    this.iconUrl,
    this.info,
    this.duration,
    this.releaseDate,
    this.isWatched = false,
    this.watchProgress,
  });

  Episode copyWith({
    int? id,
    int? episodeNumber,
    String? title,
    String? streamUrl,
    String? iconUrl,
    String? info,
    int? duration,
    DateTime? releaseDate,
    bool? isWatched,
    int? watchProgress,
  }) {
    return Episode(
      id: id ?? this.id,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      streamUrl: streamUrl ?? this.streamUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      info: info ?? this.info,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      isWatched: isWatched ?? this.isWatched,
      watchProgress: watchProgress ?? this.watchProgress,
    );
  }

  String get formattedDuration {
    if (duration == null) return '';
    final hours = duration! ~/ 3600;
    final minutes = (duration! % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  List<Object?> get props => [
        id,
        episodeNumber,
        title,
        streamUrl,
        isWatched,
        watchProgress,
      ];
}
