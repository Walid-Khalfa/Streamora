import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getLastUser();
  Future<void> clearCache();
  Future<void> saveCredentials({
    required String baseUrl,
    required String username,
    required String password,
  });
  Future<Map<String, String>?> getCredentials();
  Future<void> clearCredentials();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final Box<String> userBox;

  static const String _userKey = 'cached_user';
  static const String _credentialsKey = 'credentials';

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.userBox,
  });

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await userBox.put(_userKey, userJson);
  }

  @override
  Future<UserModel?> getLastUser() async {
    final userJson = userBox.get(_userKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel(
        username: userMap['username'],
        password: userMap['password'],
        baseUrl: userMap['base_url'],
        status: userMap['status'],
        expiryDate: userMap['expiry_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(userMap['expiry_date'])
            : null,
        maxConnections: userMap['max_connections'],
        activeConnections: userMap['active_connections'],
        isTrial: userMap['is_trial'],
        message: userMap['message'],
      );
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await userBox.delete(_userKey);
  }

  @override
  Future<void> saveCredentials({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    final credentials = {
      'base_url': baseUrl,
      'username': username,
      'password': password,
    };
    await secureStorage.write(
      key: _credentialsKey,
      value: jsonEncode(credentials),
    );
  }

  @override
  Future<Map<String, String>?> getCredentials() async {
    final credentialsJson = await secureStorage.read(key: _credentialsKey);
    if (credentialsJson != null) {
      final credentials = jsonDecode(credentialsJson) as Map<String, dynamic>;
      return {
        'base_url': credentials['base_url'],
        'username': credentials['username'],
        'password': credentials['password'],
      };
    }
    return null;
  }

  @override
  Future<void> clearCredentials() async {
    await secureStorage.delete(key: _credentialsKey);
  }
}
