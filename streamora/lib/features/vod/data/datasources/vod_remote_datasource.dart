import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/movie.dart';
import '../models/movie_model.dart';
import '../../../live/data/models/live_channel_model.dart';

part 'vod_remote_datasource.g.dart';

@Riverpod(keepAlive: true)
VodRemoteDataSource vodRemoteDataSource(Ref ref) {
  return VodRemoteDataSourceImpl(
    ref.watch(apiClientProvider),
    ref,
  );
}

abstract class VodRemoteDataSource {
  Future<List<CategoryModel>> getVodCategories();
  Future<List<MovieModel>> getVodStreams({int? categoryId});
  Future<MovieModel> getVodDetails(int movieId);
}

class VodRemoteDataSourceImpl implements VodRemoteDataSource {
  final Dio _dio;
  final Ref _ref;

  VodRemoteDataSourceImpl(this._dio, this._ref);

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
  Future<List<CategoryModel>> getVodCategories() async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      final response = await _dio.get('$baseUrl${ApiConstants.getVodCategories}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to load VOD categories',
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
  Future<List<MovieModel>> getVodStreams({int? categoryId}) async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      final queryParams = <String, dynamic>{};
      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }

      final response = await _dio.get(
        '$baseUrl${ApiConstants.getVodStreams}',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

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

        return data.map((json) => MovieModel.fromJson(
          json,
          baseUrl: baseUrl,
          username: username,
          password: password,
        )).toList();
      } else {
        throw ServerException(
          'Failed to load VOD streams',
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
  Future<MovieModel> getVodDetails(int movieId) async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      // Get credentials
      final authState = _ref.read(authNotifierProvider);
      String? username;
      String? password;
      authState.whenOrNull(
        authenticated: (_, credentials) {
          username = credentials?.username;
          password = credentials?.password;
        },
      );

      // Fetch all movies and find the one we need
      final movies = await getVodStreams();
      final movie = movies.firstWhere(
        (m) => m.id == movieId,
        orElse: () => throw const NotFoundException('Movie not found'),
      );

      return movie;
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Network error',
        code: e.response?.statusCode,
      );
    }
  }
}
