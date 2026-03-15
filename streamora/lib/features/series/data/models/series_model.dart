import '../../domain/entities/series.dart';

class SeriesModel extends Series {
  const SeriesModel({
    required super.id,
    required super.name,
    super.coverUrl,
    super.backdropUrl,
    super.plot,
    super.cast,
    super.director,
    super.genre,
    super.releaseDate,
    super.rating,
    super.lastModified,
    super.categoryId,
    super.categoryName,
    super.seasons,
    super.isFavorite,
    super.progress,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json, {String? baseUrl, String? username, String? password}) {
    final seriesId = json['series_id'] ?? json['num'] ?? 0;

    return SeriesModel(
      id: seriesId,
      name: json['name'] ?? 'Unknown Series',
      coverUrl: json['cover'] ?? json['stream_icon'] ?? json['poster'],
      backdropUrl: json['backdrop_path']?[0] ?? json['fanart'],
      plot: json['plot'] ?? json['description'],
      cast: json['cast'],
      director: json['director'],
      genre: _parseGenre(json['genre']),
      releaseDate: json['releaseDate'] ?? json['release_date'] ?? json['year']?.toString(),
      rating: json['rating']?.toString(),
      lastModified: json['last_modified'],
      categoryId: json['category_id'] != null
          ? int.tryParse(json['category_id'].toString())
          : null,
      categoryName: json['category_name'],
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true,
    );
  }

  factory SeriesModel.fromInfoJson(Map<String, dynamic> json, {String? baseUrl, String? username, String? password}) {
    final info = json['info'] ?? {};
    final seasons = <Season>[];

    // Parse episodes by season
    if (json['episodes'] != null && json['episodes'] is Map) {
      final episodesMap = json['episodes'] as Map<String, dynamic>;
      for (final entry in episodesMap.entries) {
        final seasonNum = int.tryParse(entry.key) ?? 0;
        final episodesList = entry.value as List<dynamic>;

        final episodes = episodesList.map((e) => EpisodeModel.fromJson(
          e,
          baseUrl: baseUrl,
          username: username,
          password: password,
        )).toList();

        seasons.add(Season(
          seasonNumber: seasonNum,
          name: 'Season $seasonNum',
          episodes: episodes,
        ));
      }
    }

    // Sort seasons and episodes
    seasons.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));
    for (final season in seasons) {
      season.episodes.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));
    }

    return SeriesModel(
      id: info['series_id'] ?? 0,
      name: info['name'] ?? 'Unknown Series',
      coverUrl: info['cover'] ?? info['poster'],
      backdropUrl: info['backdrop_path']?[0] ?? info['fanart'],
      plot: info['plot'] ?? info['description'],
      cast: info['cast'],
      director: info['director'],
      genre: _parseGenre(info['genre']),
      releaseDate: info['release_date'] ?? info['year']?.toString(),
      rating: info['rating']?.toString(),
      lastModified: info['last_modified'],
      seasons: seasons,
      isFavorite: info['is_favorite'] == 1 || info['is_favorite'] == true,
    );
  }

  static String? _parseGenre(dynamic genre) {
    if (genre == null) return null;
    if (genre is String) return genre;
    if (genre is List) return genre.join(', ');
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'series_id': id,
      'name': name,
      'cover': coverUrl,
      'plot': plot,
      'cast': cast,
      'director': director,
      'genre': genre,
      'releaseDate': releaseDate,
      'rating': rating,
      'category_id': categoryId?.toString(),
      'category_name': categoryName,
      'is_favorite': isFavorite,
    };
  }
}

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.id,
    required super.episodeNumber,
    required super.title,
    required super.streamUrl,
    super.coverUrl,
    super.plot,
    super.duration,
    super.releaseDate,
    super.containerExtension,
    super.progress,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json, {String? baseUrl, String? username, String? password}) {
    final episodeId = json['id'] ?? json['episode_num'] ?? 0;
    final episodeNum = json['episode_num'] ?? json['id'] ?? 0;
    final containerExt = json['container_extension'] ?? 'mp4';

    String streamUrl = json['stream_url'] ?? '';
    if (streamUrl.isEmpty && baseUrl != null && username != null && password != null) {
      final seriesId = json['series_id'] ?? 0;
      streamUrl = '$baseUrl/series/$username/$password/$seriesId/$episodeId.$containerExt';
    }

    return EpisodeModel(
      id: episodeId,
      episodeNumber: episodeNum is int ? episodeNum : int.tryParse(episodeNum.toString()) ?? 0,
      title: json['title'] ?? 'Episode $episodeNum',
      streamUrl: streamUrl,
      coverUrl: json['info']?['movie_image'] ?? json['cover'],
      plot: json['info']?['plot'] ?? json['plot'],
      duration: json['info']?['duration'] ?? json['duration'],
      releaseDate: json['info']?['releasedate'] ?? json['release_date'],
      containerExtension: containerExt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episode_num': episodeNumber,
      'title': title,
      'stream_url': streamUrl,
      'info': {
        'movie_image': coverUrl,
        'plot': plot,
        'duration': duration,
        'releasedate': releaseDate,
      },
    };
  }
}
