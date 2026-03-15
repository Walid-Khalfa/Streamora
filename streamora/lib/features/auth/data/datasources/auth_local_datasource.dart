import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

part 'auth_local_datasource.g.dart';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  ),
);

@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSourceImpl();
}

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();

  Future<void> cacheCredentials(AuthCredentialsModel credentials);
  Future<AuthCredentialsModel?> getCachedCredentials();
  Future<void> clearCachedCredentials();

  Future<void> cacheServerUrl(String url);
  Future<String?> getCachedServerUrl();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await _storage.write(
        key: AppConstants.userKey,
        value: jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await _storage.read(key: AppConstants.userKey);
      if (userJson == null) return null;

      return UserModel.fromJson(jsonDecode(userJson));
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await _storage.delete(key: AppConstants.userKey);
    } catch (e) {
      throw CacheException('Failed to clear cached user: $e');
    }
  }

  @override
  Future<void> cacheCredentials(AuthCredentialsModel credentials) async {
    try {
      await _storage.write(
        key: AppConstants.authCredentialsKey,
        value: jsonEncode(credentials.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache credentials: $e');
    }
  }

  @override
  Future<AuthCredentialsModel?> getCachedCredentials() async {
    try {
      final credentialsJson = await _storage.read(
        key: AppConstants.authCredentialsKey,
      );
      if (credentialsJson == null) return null;

      return AuthCredentialsModel.fromJson(jsonDecode(credentialsJson));
    } catch (e) {
      throw CacheException('Failed to get cached credentials: $e');
    }
  }

  @override
  Future<void> clearCachedCredentials() async {
    try {
      await _storage.delete(key: AppConstants.authCredentialsKey);
    } catch (e) {
      throw CacheException('Failed to clear cached credentials: $e');
    }
  }

  @override
  Future<void> cacheServerUrl(String url) async {
    try {
      await _storage.write(
        key: AppConstants.serverUrlKey,
        value: url,
      );
    } catch (e) {
      throw CacheException('Failed to cache server URL: $e');
    }
  }

  @override
  Future<String?> getCachedServerUrl() async {
    try {
      return await _storage.read(key: AppConstants.serverUrlKey);
    } catch (e) {
      throw CacheException('Failed to get cached server URL: $e');
    }
  }
}
