import 'package:equatable/equatable.dart';

class WatchProgress extends Equatable {
  final String id;
  final int contentId;
  final String contentType; // 'live', 'movie', 'episode'
  final String title;
  final String? iconUrl;
  final int duration;
  final int position;
  final DateTime lastWatched;
  final String? streamUrl;
  final String? category;

  const WatchProgress({
    required this.id,
    required this.contentId,
    required this.contentType,
    required this.title,
    this.iconUrl,
    required this.duration,
    required this.position,
    required this.lastWatched,
    this.streamUrl,
    this.category,
  });

  double get progressPercentage {
    if (duration <= 0) return 0.0;
    return (position / duration).clamp(0.0, 1.0);
  }

  bool get isCompleted => progressPercentage >= 0.9;
  bool get isInProgress => progressPercentage > 0.05 && !isCompleted;

  String get formattedPosition {
    return _formatDuration(position);
  }

  String get formattedDuration {
    return _formatDuration(duration);
  }

  String get remainingTime {
    final remaining = duration - position;
    return _formatDuration(remaining);
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  WatchProgress copyWith({
    String? id,
    int? contentId,
    String? contentType,
    String? title,
    String? iconUrl,
    int? duration,
    int? position,
    DateTime? lastWatched,
    String? streamUrl,
    String? category,
  }) {
    return WatchProgress(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      title: title ?? this.title,
      iconUrl: iconUrl ?? this.iconUrl,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      lastWatched: lastWatched ?? this.lastWatched,
      streamUrl: streamUrl ?? this.streamUrl,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        id,
        contentId,
        contentType,
        title,
        position,
        duration,
        lastWatched,
      ];
}
