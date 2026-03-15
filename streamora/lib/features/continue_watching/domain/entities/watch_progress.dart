import 'package:equatable/equatable.dart';

class WatchProgress extends Equatable {
  final String id;
  final int contentId;
  final String contentType;
  final String title;
  final String? coverUrl;
  final String streamUrl;
  final int position;
  final int duration;
  final double progress;
  final DateTime lastWatched;

  const WatchProgress({
    required this.id,
    required this.contentId,
    required this.contentType,
    required this.title,
    this.coverUrl,
    required this.streamUrl,
    required this.position,
    required this.duration,
    required this.progress,
    required this.lastWatched,
  });

  bool get shouldContinue => progress > 0.05 && progress < 0.95;

  WatchProgress copyWith({
    String? id,
    int? contentId,
    String? contentType,
    String? title,
    String? coverUrl,
    String? streamUrl,
    int? position,
    int? duration,
    double? progress,
    DateTime? lastWatched,
  }) {
    return WatchProgress(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      streamUrl: streamUrl ?? this.streamUrl,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      lastWatched: lastWatched ?? this.lastWatched,
    );
  }

  @override
  List<Object?> get props => [id, contentId, contentType, title, progress, lastWatched];
}
