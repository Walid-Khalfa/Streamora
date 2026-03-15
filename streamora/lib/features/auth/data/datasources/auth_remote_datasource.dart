import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

part 'auth_remote_datasource.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(ref.watch(apiClientProvider));
}

abstract class AuthRemoteDataSource {
  Future<UserModel> authenticate({
    required String baseUrl,
    required String username,
    required String password,
  });

  Future<bool> validateSession({
    required String baseUrl,
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> authenticate({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    try {
      final cleanUrl = baseUrl.replaceAll(RegExp(r'/$'), '');
      final response = await _dio.get(
        '$cleanUrl${ApiConstants.authenticate}',
        queryParameters: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['user_info'] == null) {
          throw const AuthException('Invalid credentials');
        }

        final userStatus = data['user_info']['status'];
        if (userStatus == 'Expired' || userStatus == 'Disabled') {
          throw AuthException('Account is $userStatus');
        }

        return UserModel.fromJson(data);
      } else {
        throw ServerException(
          'Authentication failed',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException('Connection timeout');
      }
      if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 403) {
        throw const AuthException('Invalid credentials');
      }
      throw ServerException(
        e.message ?? 'Network error',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> validateSession({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    try {
      final cleanUrl = baseUrl.replaceAll(RegExp(r'/$'), '');
      final response = await _dio.get(
        '$cleanUrl${ApiConstants.getAccountInfo}',
        queryParameters: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final userInfo = response.data['user_info'];
        if (userInfo == null) return false;

        final status = userInfo['status'];
        return status == 'Active';
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
