import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.name,
    required super.streamUrl,
    super.coverUrl,
    super.backdropUrl,
    super.plot,
    super.cast,
    super.director,
    super.genre,
    super.releaseDate,
    super.rating,
    super.duration,
    super.categoryId,
    super.categoryName,
    super.isFavorite,
    super.progress,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, {String? baseUrl, String? username, String? password}) {
    final streamId = json['stream_id'] ?? json['num'] ?? 0;
    final containerExtension = json['container_extension'] ?? 'mp4';

    // Build stream URL
    String streamUrl = json['stream_url'] ?? '';
    if (streamUrl.isEmpty && baseUrl != null && username != null && password != null) {
      streamUrl = '$baseUrl/movie/$username/$password/$streamId.$containerExtension';
    }

    // Parse info from stream_data if available
    final info = json['info'] ?? {};

    return MovieModel(
      id: streamId,
      name: json['name'] ?? 'Unknown Movie',
      streamUrl: streamUrl,
      coverUrl: json['stream_icon'] ?? info['movie_image'] ?? info['cover'],
      backdropUrl: info['backdrop_path']?[0] ?? info['fanart'],
      plot: info['plot'] ?? info['description'],
      cast: info['cast'],
      director: info['director'],
      genre: _parseGenre(info['genre']),
      releaseDate: info['releasedate'] ?? info['release_date'] ?? info['year']?.toString(),
      rating: info['rating']?.toString(),
      duration: info['duration'] ?? info['runtime'],
      categoryId: json['category_id'] != null
          ? int.tryParse(json['category_id'].toString())
          : null,
      categoryName: json['category_name'],
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true,
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
      'stream_id': id,
      'name': name,
      'stream_url': streamUrl,
      'stream_icon': coverUrl,
      'category_id': categoryId?.toString(),
      'category_name': categoryName,
      'info': {
        'plot': plot,
        'cast': cast,
        'director': director,
        'genre': genre,
        'releasedate': releaseDate,
        'rating': rating,
        'duration': duration,
      },
      'is_favorite': isFavorite,
    };
  }
}
