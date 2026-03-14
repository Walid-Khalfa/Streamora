import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

abstract class FavoritesLocalDataSource {
  Future<void> addFavorite({
    required String type,
    required int id,
    required Map<String, dynamic> data,
  });
  
  Future<void> removeFavorite({
    required String type,
    required int id,
  });
  
  Future<bool> isFavorite({
    required String type,
    required int id,
  });
  
  Future<List<Map<String, dynamic>>> getFavorites(String type);
  
  Future<void> clearFavorites(String type);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final Box<String> favoritesBox;

  FavoritesLocalDataSourceImpl(this.favoritesBox);

  String _getKey(String type, int id) => '${type}_$id';
  String _getTypePrefix(String type) => '${type}_';

  @override
  Future<void> addFavorite({
    required String type,
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final key = _getKey(type, id);
    await favoritesBox.put(key, jsonEncode(data));
  }

  @override
  Future<void> removeFavorite({
    required String type,
    required int id,
  }) async {
    final key = _getKey(type, id);
    await favoritesBox.delete(key);
  }

  @override
  Future<bool> isFavorite({
    required String type,
    required int id,
  }) async {
    final key = _getKey(type, id);
    return favoritesBox.containsKey(key);
  }

  @override
  Future<List<Map<String, dynamic>>> getFavorites(String type) async {
    final prefix = _getTypePrefix(type);
    final favorites = <Map<String, dynamic>>[];
    
    for (final key in favoritesBox.keys) {
      if (key.toString().startsWith(prefix)) {
        final data = favoritesBox.get(key);
        if (data != null) {
          favorites.add(jsonDecode(data) as Map<String, dynamic>);
        }
      }
    }
    
    return favorites;
  }

  @override
  Future<void> clearFavorites(String type) async {
    final prefix = _getTypePrefix(type);
    final keysToDelete = favoritesBox.keys
        .where((key) => key.toString().startsWith(prefix))
        .toList();
    
    await favoritesBox.deleteAll(keysToDelete);
  }
}
