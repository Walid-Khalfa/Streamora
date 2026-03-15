import 'package:equatable/equatable.dart';

class Series extends Equatable {
  final int id;
  final String name;
  final String? coverUrl;
  final String? backdropUrl;
  final String? plot;
  final String? cast;
  final String? director;
  final String? genre;
  final String? releaseDate;
  final String? rating;
  final String? lastModified;
  final int? categoryId;
  final String? categoryName;
  final List<Season> seasons;
  final bool isFavorite;
  final double? progress;

  const Series({
    required this.id,
    required this.name,
    this.coverUrl,
    this.backdropUrl,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.releaseDate,
    this.rating,
    this.lastModified,
    this.categoryId,
    this.categoryName,
    this.seasons = const [],
    this.isFavorite = false,
    this.progress,
  });

  int get totalEpisodes {
    return seasons.fold(0, (sum, season) => sum + season.episodes.length);
  }

  Series copyWith({
    int? id,
    String? name,
    String? coverUrl,
    String? backdropUrl,
    String? plot,
    String? cast,
    String? director,
    String? genre,
    String? releaseDate,
    String? rating,
    String? lastModified,
    int? categoryId,
    String? categoryName,
    List<Season>? seasons,
    bool? isFavorite,
    double? progress,
  }) {
    return Series(
      id: id ?? this.id,
      name: name ?? this.name,
      coverUrl: coverUrl ?? this.coverUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      plot: plot ?? this.plot,
      cast: cast ?? this.cast,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      releaseDate: releaseDate ?? this.releaseDate,
      rating: rating ?? this.rating,
      lastModified: lastModified ?? this.lastModified,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      seasons: seasons ?? this.seasons,
      isFavorite: isFavorite ?? this.isFavorite,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        coverUrl,
        isFavorite,
        progress,
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
  final String? coverUrl;
  final String? plot;
  final String? duration;
  final String? releaseDate;
  final String? containerExtension;
  final double? progress;

  const Episode({
    required this.id,
    required this.episodeNumber,
    required this.title,
    required this.streamUrl,
    this.coverUrl,
    this.plot,
    this.duration,
    this.releaseDate,
    this.containerExtension,
    this.progress,
  });

  Episode copyWith({
    int? id,
    int? episodeNumber,
    String? title,
    String? streamUrl,
    String? coverUrl,
    String? plot,
    String? duration,
    String? releaseDate,
    String? containerExtension,
    double? progress,
  }) {
    return Episode(
      id: id ?? this.id,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      streamUrl: streamUrl ?? this.streamUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      plot: plot ?? this.plot,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      containerExtension: containerExtension ?? this.containerExtension,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        episodeNumber,
        title,
        streamUrl,
        progress,
      ];
}
