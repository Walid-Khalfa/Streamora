import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../live/data/models/live_channel_model.dart';
import '../models/series_model.dart';

part 'series_remote_datasource.g.dart';

@Riverpod(keepAlive: true)
SeriesRemoteDataSource seriesRemoteDataSource(Ref ref) {
  return SeriesRemoteDataSourceImpl(
    ref.watch(apiClientProvider),
    ref,
  );
}

abstract class SeriesRemoteDataSource {
  Future<List<CategoryModel>> getSeriesCategories();
  Future<List<SeriesModel>> getSeries({int? categoryId});
  Future<SeriesModel> getSeriesInfo(int seriesId);
}

class SeriesRemoteDataSourceImpl implements SeriesRemoteDataSource {
  final Dio _dio;
  final Ref _ref;

  SeriesRemoteDataSourceImpl(this._dio, this._ref);

  String? _getBaseUrl() {
    final authState = _ref.read(authNotifierProvider);
    String? baseUrl;
    authState.whenOrNull(
      authenticated: (user, _) {
        baseUrl = user.serverInfo.baseUrl;
      },
    );
    return baseUrl;
  }

  @override
  Future<List<CategoryModel>> getSeriesCategories() async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      final response = await _dio.get('$baseUrl${ApiConstants.getSeriesCategories}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to load series categories',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Network error',
        code: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<SeriesModel>> getSeries({int? categoryId}) async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      final queryParams = <String, dynamic>{};
      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }

      final response = await _dio.get(
        '$baseUrl${ApiConstants.getSeries}',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SeriesModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to load series',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Network error',
        code: e.response?.statusCode,
      );
    }
  }

  @override
  Future<SeriesModel> getSeriesInfo(int seriesId) async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      final response = await _dio.get(
        '$baseUrl${ApiConstants.getSeriesInfo}',
        queryParameters: {'series_id': seriesId.toString()},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Get credentials for building stream URLs
        final authState = _ref.read(authNotifierProvider);
        String? username;
        String? password;
        authState.whenOrNull(
          authenticated: (_, credentials) {
            username = credentials?.username;
            password = credentials?.password;
          },
        );

        return SeriesModel.fromInfoJson(
          data,
          baseUrl: baseUrl,
          username: username,
          password: password,
        );
      } else {
        throw ServerException(
          'Failed to load series info',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Network error',
        code: e.response?.statusCode,
      );
    }
  }
}
