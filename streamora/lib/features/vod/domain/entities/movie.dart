import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String name;
  final String streamUrl;
  final String? coverUrl;
  final String? backdropUrl;
  final String? plot;
  final String? cast;
  final String? director;
  final String? genre;
  final String? releaseDate;
  final String? rating;
  final String? duration;
  final int? categoryId;
  final String? categoryName;
  final bool isFavorite;
  final double? progress;

  const Movie({
    required this.id,
    required this.name,
    required this.streamUrl,
    this.coverUrl,
    this.backdropUrl,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.releaseDate,
    this.rating,
    this.duration,
    this.categoryId,
    this.categoryName,
    this.isFavorite = false,
    this.progress,
  });

  Movie copyWith({
    int? id,
    String? name,
    String? streamUrl,
    String? coverUrl,
    String? backdropUrl,
    String? plot,
    String? cast,
    String? director,
    String? genre,
    String? releaseDate,
    String? rating,
    String? duration,
    int? categoryId,
    String? categoryName,
    bool? isFavorite,
    double? progress,
  }) {
    return Movie(
      id: id ?? this.id,
      name: name ?? this.name,
      streamUrl: streamUrl ?? this.streamUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      plot: plot ?? this.plot,
      cast: cast ?? this.cast,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      releaseDate: releaseDate ?? this.releaseDate,
      rating: rating ?? this.rating,
      duration: duration ?? this.duration,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      isFavorite: isFavorite ?? this.isFavorite,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        streamUrl,
        coverUrl,
        isFavorite,
        progress,
      ];
}
