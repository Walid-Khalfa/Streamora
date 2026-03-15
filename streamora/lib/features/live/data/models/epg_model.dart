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
    super.imageUrl,
    super.isCurrent,
  });

  factory EpgProgramModel.fromJson(Map<String, dynamic> json, int channelId) {
    DateTime? parseTimestamp(dynamic timestamp) {
      if (timestamp == null) return null;
      if (timestamp is int) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      }
      if (timestamp is String) {
        // Try parsing as timestamp first
        final ts = int.tryParse(timestamp);
        if (ts != null) {
          return DateTime.fromMillisecondsSinceEpoch(ts * 1000);
        }
        // Try parsing as ISO date
        return DateTime.tryParse(timestamp);
      }
      return null;
    }

    final startTime = parseTimestamp(json['start_timestamp'] ?? json['start']) ?? DateTime.now();
    final endTime = parseTimestamp(json['stop_timestamp'] ?? json['stop'] ?? json['end']) ?? 
        startTime.add(const Duration(hours: 1));

    return EpgProgramModel(
      id: json['id']?.toString() ?? '${channelId}_${startTime.millisecondsSinceEpoch}',
      channelId: channelId,
      title: json['title'] ?? 'Unknown Program',
      description: json['description'] ?? json['desc'],
      startTime: startTime,
      endTime: endTime,
      category: json['category'] ?? json['genre'],
      imageUrl: json['cover'] ?? json['image'] ?? json['icon'],
      isCurrent: json['now_playing'] == 1 || json['now_playing'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'title': title,
      'description': description,
      'start_timestamp': startTime.millisecondsSinceEpoch ~/ 1000,
      'stop_timestamp': endTime.millisecondsSinceEpoch ~/ 1000,
      'category': category,
      'cover': imageUrl,
      'now_playing': isCurrent,
    };
  }
}
