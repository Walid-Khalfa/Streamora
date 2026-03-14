import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.name,
    required super.streamUrl,
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
    super.duration,
    super.isFavorite = false,
    super.added,
    super.containerExtension,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, {
    required String baseUrl,
    required String username,
    required String password,
  }) {
    final streamId = json['stream_id'] ?? 0;
    final extension = json['container_extension'] ?? 'mp4';
    final info = json['info'] ?? {};
    
    DateTime? added;
    if (json['added'] != null) {
      try {
        added = DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['added'].toString()) * 1000,
        );
      } catch (_) {}
    }

    return MovieModel(
      id: streamId,
      name: json['name'] ?? 'Unknown Movie',
      streamUrl: '$baseUrl/movie/$username/$password/$streamId.$extension',
      iconUrl: json['stream_icon']?.toString().isNotEmpty == true
          ? json['stream_icon']
          : null,
      posterUrl: info['movie_image']?.toString().isNotEmpty == true
          ? info['movie_image']
          : null,
      backdropUrl: info['backdrop_path']?.toString().isNotEmpty == true
          ? info['backdrop_path'][0]
          : null,
      categoryId: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      categoryName: json['category_name'] ?? 'Unknown Category',
      rating: info['rating']?.toString(),
      year: info['year']?.toString() ?? info['release_date']?.toString(),
      plot: info['plot']?.toString(),
      cast: info['cast']?.toString(),
      director: info['director']?.toString(),
      genre: info['genre']?.toString(),
      duration: info['duration_secs'] != null
          ? int.tryParse(info['duration_secs'].toString())
          : null,
      added: added,
      containerExtension: extension,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stream_id': id,
      'name': name,
      'stream_icon': iconUrl,
      'category_id': categoryId,
      'category_name': categoryName,
      'container_extension': containerExtension,
    };
  }

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      name: movie.name,
      streamUrl: movie.streamUrl,
      iconUrl: movie.iconUrl,
      posterUrl: movie.posterUrl,
      backdropUrl: movie.backdropUrl,
      categoryId: movie.categoryId,
      categoryName: movie.categoryName,
      rating: movie.rating,
      year: movie.year,
      plot: movie.plot,
      cast: movie.cast,
      director: movie.director,
      genre: movie.genre,
      duration: movie.duration,
      isFavorite: movie.isFavorite,
      added: movie.added,
      containerExtension: movie.containerExtension,
    );
  }
}
