import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/series_model.dart';
import '../../../live/domain/entities/category.dart';

abstract class SeriesRemoteDataSource {
  Future<List<Category>> getCategories({
    required String baseUrl,
    required String username,
    required String password,
  });

  Future<List<SeriesModel>> getSeries({
    required String baseUrl,
    required String username,
    required String password,
    int? categoryId,
  });

  Future<SeriesModel> getSeriesInfo({
    required String baseUrl,
    required String username,
    required String password,
    required int seriesId,
  });
}

class SeriesRemoteDataSourceImpl implements SeriesRemoteDataSource {
  final ApiClient apiClient;

  SeriesRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Category>> getCategories({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    final url = '$baseUrl/player_api.php?username=$username&password=$password&action=get_series_categories';
    
    final response = await apiClient.dio.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Category(
        id: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
        name: json['category_name'] ?? 'Unknown',
        type: 'series',
      )).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Failed to load series categories',
      );
    }
  }

  @override
  Future<List<SeriesModel>> getSeries({
    required String baseUrl,
    required String username,
    required String password,
    int? categoryId,
  }) async {
    String url = '$baseUrl/player_api.php?username=$username&password=$password&action=get_series';
    
    if (categoryId != null) {
      url += '&category_id=$categoryId';
    }
    
    final response = await apiClient.dio.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => SeriesModel.fromJson(
        json,
        baseUrl: baseUrl,
        username: username,
        password: password,
      )).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Failed to load series',
      );
    }
  }

  @override
  Future<SeriesModel> getSeriesInfo({
    required String baseUrl,
    required String username,
    required String password,
    required int seriesId,
  }) async {
    final url = '$baseUrl/player_api.php?username=$username&password=$password&action=get_series_info&series_id=$seriesId';
    
    final response = await apiClient.dio.get(url);
    
    if (response.statusCode == 200) {
      return SeriesModel.fromJson(
        response.data,
        baseUrl: baseUrl,
        username: username,
        password: password,
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Failed to load series info',
      );
    }
  }
}
