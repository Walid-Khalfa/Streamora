import '../../domain/entities/series.dart';

class SeriesModel extends Series {
  const SeriesModel({
    required super.id,
    required super.name,
    super.iconUrl,
    super.posterUrl,
    super.backdropUrl,
    required super.categoryId,
    required super.categoryName,
    super.rating,
    super.year,
    super.plot,
    super.cast,
    super.director,
    super.genre,
    super.isFavorite = false,
    super.added,
    super.seasons = const [],
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json, {
    required String baseUrl,
    required String username,
    required String password,
  }) {
    final info = json['info'] ?? {};
    
    DateTime? added;
    if (json['added'] != null) {
      try {
        added = DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['added'].toString()) * 1000,
        );
      } catch (_) {}
    }

    // Parse seasons and episodes if available
    List<Season> seasons = [];
    if (json['episodes'] != null) {
      final episodesMap = json['episodes'] as Map<String, dynamic>;
      seasons = episodesMap.entries.map((entry) {
        final seasonNum = int.tryParse(entry.key) ?? 0;
        final episodesList = entry.value as List<dynamic>;
        
        return Season(
          seasonNumber: seasonNum,
          name: 'Season $seasonNum',
          episodes: episodesList.map((ep) => Episode(
            id: int.tryParse(ep['id']?.toString() ?? '0') ?? 0,
            episodeNumber: int.tryParse(ep['episode_num']?.toString() ?? '0') ?? 0,
            title: ep['title'] ?? 'Episode ${ep['episode_num']}',
            streamUrl: '$baseUrl/series/$username/$password/${ep['id']}.${ep['container_extension'] ?? 'mp4'}',
            iconUrl: ep['info']?['movie_image'],
            info: ep['info']?['plot'],
            duration: ep['info']?['duration_secs'] != null
                ? int.tryParse(ep['info']['duration_secs'].toString())
                : null,
            releaseDate: ep['info']?['releasedate'] != null
                ? DateTime.tryParse(ep['info']['releasedate'])
                : null,
          )).toList(),
        );
      }).toList();
      
      // Sort seasons by number
      seasons.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));
    }

    return SeriesModel(
      id: int.tryParse(json['series_id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? info['name'] ?? 'Unknown Series',
      iconUrl: json['cover']?.toString().isNotEmpty == true
          ? json['cover']
          : info['cover']?.toString().isNotEmpty == true
              ? info['cover']
              : null,
      posterUrl: info['cover']?.toString().isNotEmpty == true
          ? info['cover']
          : null,
      backdropUrl: info['backdrop_path']?.toString().isNotEmpty == true
          ? info['backdrop_path'][0]
          : null,
      categoryId: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      categoryName: json['category_name'] ?? 'Unknown Category',
      rating: info['rating']?.toString(),
      year: info['year']?.toString() ?? info['releaseDate']?.toString(),
      plot: info['plot']?.toString() ?? info[' synopsis']?.toString(),
      cast: info['cast']?.toString(),
      director: info['director']?.toString(),
      genre: info['genre']?.toString(),
      added: added,
      seasons: seasons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'series_id': id,
      'name': name,
      'cover': iconUrl,
      'category_id': categoryId,
      'category_name': categoryName,
    };
  }

  factory SeriesModel.fromEntity(Series series) {
    return SeriesModel(
      id: series.id,
      name: series.name,
      iconUrl: series.iconUrl,
      posterUrl: series.posterUrl,
      backdropUrl: series.backdropUrl,
      categoryId: series.categoryId,
      categoryName: series.categoryName,
      rating: series.rating,
      year: series.year,
      plot: series.plot,
      cast: series.cast,
      director: series.director,
      genre: series.genre,
      isFavorite: series.isFavorite,
      added: series.added,
      seasons: series.seasons,
    );
  }
}
