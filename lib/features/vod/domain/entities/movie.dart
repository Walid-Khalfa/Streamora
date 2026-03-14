import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String name;
  final String streamUrl;
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
  final int? duration;
  final bool isFavorite;
  final DateTime? added;
  final String? containerExtension;

  const Movie({
    required this.id,
    required this.name,
    required this.streamUrl,
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
    this.duration,
    this.isFavorite = false,
    this.added,
    this.containerExtension,
  });

  Movie copyWith({
    int? id,
    String? name,
    String? streamUrl,
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
    int? duration,
    bool? isFavorite,
    DateTime? added,
    String? containerExtension,
  }) {
    return Movie(
      id: id ?? this.id,
      name: name ?? this.name,
      streamUrl: streamUrl ?? this.streamUrl,
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
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
      added: added ?? this.added,
      containerExtension: containerExtension ?? this.containerExtension,
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
        name,
        streamUrl,
        iconUrl,
        categoryId,
        categoryName,
        rating,
        year,
        isFavorite,
      ];
}
