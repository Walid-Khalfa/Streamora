import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../models/watch_progress_model.dart';

abstract class WatchHistoryLocalDataSource {
  Future<void> saveProgress(WatchProgressModel progress);
  Future<WatchProgressModel?> getProgress(String contentType, int contentId);
  Future<List<WatchProgressModel>> getAllProgress();
  Future<void> deleteProgress(String contentType, int contentId);
  Future<void> clearAllProgress();
}

class WatchHistoryLocalDataSourceImpl implements WatchHistoryLocalDataSource {
  final Database database;

  WatchHistoryLocalDataSourceImpl(this.database);

  static const String tableName = 'watch_history';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        content_id INTEGER NOT NULL,
        content_type TEXT NOT NULL,
        title TEXT NOT NULL,
        icon_url TEXT,
        duration INTEGER NOT NULL,
        position INTEGER NOT NULL,
        last_watched TEXT NOT NULL,
        stream_url TEXT,
        category TEXT,
        UNIQUE(content_type, content_id)
      )
    ''');
    
    await db.execute('''
      CREATE INDEX idx_content ON $tableName(content_type, content_id)
    ''');
    
    await db.execute('''
      CREATE INDEX idx_last_watched ON $tableName(last_watched DESC)
    ''');
  }

  @override
  Future<void> saveProgress(WatchProgressModel progress) async {
    await database.insert(
      tableName,
      progress.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<WatchProgressModel?> getProgress(String contentType, int contentId) async {
    final results = await database.query(
      tableName,
      where: 'content_type = ? AND content_id = ?',
      whereArgs: [contentType, contentId],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return WatchProgressModel.fromJson(results.first);
    }
    return null;
  }

  @override
  Future<List<WatchProgressModel>> getAllProgress() async {
    final results = await database.query(
      tableName,
      orderBy: 'last_watched DESC',
    );

    return results.map((json) => WatchProgressModel.fromJson(json)).toList();
  }

  @override
  Future<void> deleteProgress(String contentType, int contentId) async {
    await database.delete(
      tableName,
      where: 'content_type = ? AND content_id = ?',
      whereArgs: [contentType, contentId],
    );
  }

  @override
  Future<void> clearAllProgress() async {
    await database.delete(tableName);
  }
}
