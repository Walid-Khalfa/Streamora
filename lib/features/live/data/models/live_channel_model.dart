import '../../domain/entities/live_channel.dart';

class LiveChannelModel extends LiveChannel {
  const LiveChannelModel({
    required super.id,
    required super.name,
    required super.streamUrl,
    super.iconUrl,
    required super.categoryId,
    required super.categoryName,
    super.isFavorite = false,
    super.epgId,
    super.epgName,
    super.streamType,
  });

  factory LiveChannelModel.fromJson(Map<String, dynamic> json, {
    required String baseUrl,
    required String username,
    required String password,
  }) {
    final streamId = json['stream_id'] ?? json['num'] ?? 0;
    final extension = json['container_extension'] ?? 'ts';
    
    return LiveChannelModel(
      id: streamId,
      name: json['name'] ?? 'Unknown Channel',
      streamUrl: '$baseUrl/live/$username/$password/$streamId.$extension',
      iconUrl: json['stream_icon']?.toString().isNotEmpty == true
          ? json['stream_icon']
          : null,
      categoryId: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      categoryName: json['category_name'] ?? 'Unknown Category',
      epgId: json['epg_channel_id'] != null
          ? int.tryParse(json['epg_channel_id'].toString())
          : null,
      epgName: json['epg_name'],
      streamType: json['stream_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stream_id': id,
      'name': name,
      'stream_icon': iconUrl,
      'category_id': categoryId,
      'category_name': categoryName,
      'epg_channel_id': epgId,
      'epg_name': epgName,
      'stream_type': streamType,
    };
  }

  factory LiveChannelModel.fromEntity(LiveChannel channel) {
    return LiveChannelModel(
      id: channel.id,
      name: channel.name,
      streamUrl: channel.streamUrl,
      iconUrl: channel.iconUrl,
      categoryId: channel.categoryId,
      categoryName: channel.categoryName,
      isFavorite: channel.isFavorite,
      epgId: channel.epgId,
      epgName: channel.epgName,
      streamType: channel.streamType,
    );
  }
}
