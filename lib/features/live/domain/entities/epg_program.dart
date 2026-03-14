import 'package:equatable/equatable.dart';

class EpgProgram extends Equatable {
  final int id;
  final int channelId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? category;
  final String? rating;
  final String? poster;

  const EpgProgram({
    required this.id,
    required this.channelId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.category,
    this.rating,
    this.poster,
  });

  bool get isCurrent {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  bool get isPast => DateTime.now().isAfter(endTime);
  bool get isFuture => DateTime.now().isBefore(startTime);

  Duration get duration => endTime.difference(startTime);
  Duration get remainingTime => endTime.difference(DateTime.now());

  double get progressPercentage {
    if (isFuture) return 0.0;
    if (isPast) return 1.0;
    
    final totalDuration = duration.inSeconds;
    final elapsed = DateTime.now().difference(startTime).inSeconds;
    return (elapsed / totalDuration).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
        id,
        channelId,
        title,
        description,
        startTime,
        endTime,
        category,
        rating,
        poster,
      ];
}
