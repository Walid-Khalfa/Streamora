import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../models/epg_model.dart';
import '../models/live_channel_model.dart';

part 'live_remote_datasource.g.dart';

@Riverpod(keepAlive: true)
LiveRemoteDataSource liveRemoteDataSource(Ref ref) {
  return LiveRemoteDataSourceImpl(
    ref.watch(apiClientProvider),
    ref,
  );
}

abstract class LiveRemoteDataSource {
  Future<List<CategoryModel>> getLiveCategories();
  Future<List<LiveChannelModel>> getLiveStreams({int? categoryId});
  Future<List<EpgProgramModel>> getEpgForChannel(int channelId, {int? limit});
  Future<List<EpgProgramModel>> getShortEpgForChannel(int channelId, {int? limit});
}

class LiveRemoteDataSourceImpl implements LiveRemoteDataSource {
  final Dio _dio;
  final Ref _ref;

  LiveRemoteDataSourceImpl(this._dio, this._ref);

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
  Future<List<CategoryModel>> getLiveCategories() async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      final response = await _dio.get('$baseUrl${ApiConstants.getLiveCategories}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to load categories',
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
  Future<List<LiveChannelModel>> getLiveStreams({int? categoryId}) async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      final queryParams = <String, dynamic>{};
      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }

      final response = await _dio.get(
        '$baseUrl${ApiConstants.getLiveStreams}',
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

        return data.map((json) => LiveChannelModel.fromJson(
          json,
          baseUrl: baseUrl,
          username: username,
          password: password,
        )).toList();
      } else {
        throw ServerException(
          'Failed to load live streams',
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
  Future<List<EpgProgramModel>> getEpgForChannel(int channelId, {int? limit}) async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      final queryParams = <String, dynamic>{
        'stream_id': channelId.toString(),
      };
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      final response = await _dio.get(
        '$baseUrl${ApiConstants.getEpg}',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => EpgProgramModel.fromJson(json, channelId)).toList();
        } else if (data is Map && data['epg_listings'] != null) {
          final List<dynamic> listings = data['epg_listings'];
          return listings.map((json) => EpgProgramModel.fromJson(json, channelId)).toList();
        }
        return [];
      } else {
        throw ServerException(
          'Failed to load EPG',
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
  Future<List<EpgProgramModel>> getShortEpgForChannel(int channelId, {int? limit}) async {
    try {
      final baseUrl = _getBaseUrl();
      if (baseUrl == null) throw const AuthException('Not authenticated');

      final queryParams = <String, dynamic>{
        'stream_id': channelId.toString(),
      };
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      final response = await _dio.get(
        '$baseUrl${ApiConstants.getShortEpg}',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => EpgProgramModel.fromJson(json, channelId)).toList();
        } else if (data is Map && data['epg_listings'] != null) {
          final List<dynamic> listings = data['epg_listings'];
          return listings.map((json) => EpgProgramModel.fromJson(json, channelId)).toList();
        }
        return [];
      } else {
        throw ServerException(
          'Failed to load short EPG',
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
