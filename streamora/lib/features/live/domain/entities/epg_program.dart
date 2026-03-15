import 'package:equatable/equatable.dart';

class EpgProgram extends Equatable {
  final String id;
  final int channelId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? category;
  final String? imageUrl;
  final bool isCurrent;

  const EpgProgram({
    required this.id,
    required this.channelId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.category,
    this.imageUrl,
    this.isCurrent = false,
  });

  Duration get duration => endTime.difference(startTime);
  
  Duration get timeElapsed => DateTime.now().difference(startTime);
  
  double get progressPercentage {
    final total = duration.inSeconds;
    final elapsed = timeElapsed.inSeconds;
    if (total <= 0) return 0;
    return (elapsed / total).clamp(0, 1);
  }

  bool get isPlayingNow {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  EpgProgram copyWith({
    String? id,
    int? channelId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? category,
    String? imageUrl,
    bool? isCurrent,
  }) {
    return EpgProgram(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  @override
  List<Object?> get props => [
        id,
        channelId,
        title,
        startTime,
        endTime,
      ];
}
