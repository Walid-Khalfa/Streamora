import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/live_channel_model.dart';
import '../../domain/entities/category.dart';

abstract class LiveRemoteDataSource {
  Future<List<Category>> getCategories({
    required String baseUrl,
    required String username,
    required String password,
  });

  Future<List<LiveChannelModel>> getChannels({
    required String baseUrl,
    required String username,
    required String password,
    int? categoryId,
  });
}

class LiveRemoteDataSourceImpl implements LiveRemoteDataSource {
  final ApiClient apiClient;

  LiveRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Category>> getCategories({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    final url = '$baseUrl/player_api.php?username=$username&password=$password&action=get_live_categories';
    
    final response = await apiClient.dio.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Category(
        id: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
        name: json['category_name'] ?? 'Unknown',
        type: 'live',
      )).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Failed to load categories',
      );
    }
  }

  @override
  Future<List<LiveChannelModel>> getChannels({
    required String baseUrl,
    required String username,
    required String password,
    int? categoryId,
  }) async {
    String url = '$baseUrl/player_api.php?username=$username&password=$password&action=get_live_streams';
    
    if (categoryId != null) {
      url += '&category_id=$categoryId';
    }
    
    final response = await apiClient.dio.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => LiveChannelModel.fromJson(
        json,
        baseUrl: baseUrl,
        username: username,
        password: password,
      )).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Failed to load channels',
      );
    }
  }
}
