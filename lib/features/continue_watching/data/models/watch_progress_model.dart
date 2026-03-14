import '../../domain/entities/watch_progress.dart';

class WatchProgressModel extends WatchProgress {
  const WatchProgressModel({
    required super.id,
    required super.contentId,
    required super.contentType,
    required super.title,
    super.iconUrl,
    required super.duration,
    required super.position,
    required super.lastWatched,
    super.streamUrl,
    super.category,
  });

  factory WatchProgressModel.fromJson(Map<String, dynamic> json) {
    return WatchProgressModel(
      id: json['id'],
      contentId: json['content_id'],
      contentType: json['content_type'],
      title: json['title'],
      iconUrl: json['icon_url'],
      duration: json['duration'],
      position: json['position'],
      lastWatched: DateTime.parse(json['last_watched']),
      streamUrl: json['stream_url'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content_id': contentId,
      'content_type': contentType,
      'title': title,
      'icon_url': iconUrl,
      'duration': duration,
      'position': position,
      'last_watched': lastWatched.toIso8601String(),
      'stream_url': streamUrl,
      'category': category,
    };
  }

  factory WatchProgressModel.fromEntity(WatchProgress progress) {
    return WatchProgressModel(
      id: progress.id,
      contentId: progress.contentId,
      contentType: progress.contentType,
      title: progress.title,
      iconUrl: progress.iconUrl,
      duration: progress.duration,
      position: progress.position,
      lastWatched: progress.lastWatched,
      streamUrl: progress.streamUrl,
      category: progress.category,
    );
  }
}
