import 'package:equatable/equatable.dart';

class LiveChannel extends Equatable {
  final int id;
  final String name;
  final String streamUrl;
  final String? iconUrl;
  final int categoryId;
  final String categoryName;
  final bool isFavorite;
  final int? epgId;
  final String? epgName;
  final String? streamType;

  const LiveChannel({
    required this.id,
    required this.name,
    required this.streamUrl,
    this.iconUrl,
    required this.categoryId,
    required this.categoryName,
    this.isFavorite = false,
    this.epgId,
    this.epgName,
    this.streamType,
  });

  LiveChannel copyWith({
    int? id,
    String? name,
    String? streamUrl,
    String? iconUrl,
    int? categoryId,
    String? categoryName,
    bool? isFavorite,
    int? epgId,
    String? epgName,
    String? streamType,
  }) {
    return LiveChannel(
      id: id ?? this.id,
      name: name ?? this.name,
      streamUrl: streamUrl ?? this.streamUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      isFavorite: isFavorite ?? this.isFavorite,
      epgId: epgId ?? this.epgId,
      epgName: epgName ?? this.epgName,
      streamType: streamType ?? this.streamType,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        streamUrl,
        iconUrl,
        categoryId,
        categoryName,
        isFavorite,
        epgId,
        epgName,
        streamType,
      ];
}
