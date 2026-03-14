import '../../domain/entities/epg_program.dart';

class EpgProgramModel extends EpgProgram {
  const EpgProgramModel({
    required super.id,
    required super.channelId,
    required super.title,
    super.description,
    required super.startTime,
    required super.endTime,
    super.category,
    super.rating,
    super.poster,
  });

  factory EpgProgramModel.fromJson(Map<String, dynamic> json) {
    DateTime parseTime(String? timeStr) {
      if (timeStr == null) return DateTime.now();
      try {
        // Try parsing Unix timestamp
        final timestamp = int.tryParse(timeStr);
        if (timestamp != null) {
          return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        }
        // Try parsing ISO format
        return DateTime.parse(timeStr);
      } catch (_) {
        return DateTime.now();
      }
    }

    return EpgProgramModel(
      id: json['id'] ?? 0,
      channelId: int.tryParse(json['channel_id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? 'Unknown Program',
      description: json['description'],
      startTime: parseTime(json['start']?.toString() ?? json['start_timestamp']?.toString()),
      endTime: parseTime(json['end']?.toString() ?? json['stop_timestamp']?.toString()),
      category: json['category'],
      rating: json['rating'],
      poster: json['poster']?.toString().isNotEmpty == true ? json['poster'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'title': title,
      'description': description,
      'start': startTime.millisecondsSinceEpoch ~/ 1000,
      'end': endTime.millisecondsSinceEpoch ~/ 1000,
      'category': category,
      'rating': rating,
      'poster': poster,
    };
  }
}
