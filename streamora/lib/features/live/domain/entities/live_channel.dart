import 'package:equatable/equatable.dart';

class LiveChannel extends Equatable {
  final int id;
  final String name;
  final String streamUrl;
  final String? iconUrl;
  final int? categoryId;
  final String? categoryName;
  final String? epgChannelId;
  final bool isFavorite;

  const LiveChannel({
    required this.id,
    required this.name,
    required this.streamUrl,
    this.iconUrl,
    this.categoryId,
    this.categoryName,
    this.epgChannelId,
    this.isFavorite = false,
  });

  LiveChannel copyWith({
    int? id,
    String? name,
    String? streamUrl,
    String? iconUrl,
    int? categoryId,
    String? categoryName,
    String? epgChannelId,
    bool? isFavorite,
  }) {
    return LiveChannel(
      id: id ?? this.id,
      name: name ?? this.name,
      streamUrl: streamUrl ?? this.streamUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      epgChannelId: epgChannelId ?? this.epgChannelId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        streamUrl,
        iconUrl,
        categoryId,
        epgChannelId,
        isFavorite,
      ];
}

class Category extends Equatable {
  final int id;
  final String name;
  final int? parentId;

  const Category({
    required this.id,
    required this.name,
    this.parentId,
  });

  @override
  List<Object?> get props => [id, name, parentId];
}
