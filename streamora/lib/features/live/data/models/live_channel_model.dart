import '../../domain/entities/live_channel.dart';

class LiveChannelModel extends LiveChannel {
  const LiveChannelModel({
    required super.id,
    required super.name,
    required super.streamUrl,
    super.iconUrl,
    super.categoryId,
    super.categoryName,
    super.epgChannelId,
    super.isFavorite,
  });

  factory LiveChannelModel.fromJson(Map<String, dynamic> json, {String? baseUrl, String? username, String? password}) {
    final streamId = json['stream_id'] ?? json['num'] ?? 0;
    
    // Construct stream URL if not provided
    String streamUrl = json['stream_url'] ?? '';
    if (streamUrl.isEmpty && baseUrl != null && username != null && password != null) {
      final extension = json['container_extension'] ?? 'ts';
      streamUrl = '$baseUrl/live/$username/$password/$streamId.$extension';
    }

    return LiveChannelModel(
      id: streamId,
      name: json['name'] ?? 'Unknown Channel',
      streamUrl: streamUrl,
      iconUrl: json['stream_icon'] ?? json['logo'] ?? json['icon'],
      categoryId: json['category_id'] != null 
          ? int.tryParse(json['category_id'].toString()) 
          : null,
      categoryName: json['category_name'],
      epgChannelId: json['epg_channel_id']?.toString(),
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stream_id': id,
      'name': name,
      'stream_url': streamUrl,
      'stream_icon': iconUrl,
      'category_id': categoryId?.toString(),
      'category_name': categoryName,
      'epg_channel_id': epgChannelId,
      'is_favorite': isFavorite,
    };
  }
}

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: int.tryParse(json['category_id'].toString()) ?? 0,
      name: json['category_name'] ?? 'Unknown',
      parentId: json['parent_id'] != null 
          ? int.tryParse(json['parent_id'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': id.toString(),
      'category_name': name,
      'parent_id': parentId?.toString(),
    };
  }
}
