import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie_model.dart';
import '../../../live/domain/entities/category.dart';

abstract class VodRemoteDataSource {
  Future<List<Category>> getCategories({
    required String baseUrl,
    required String username,
    required String password,
  });

  Future<List<MovieModel>> getMovies({
    required String baseUrl,
    required String username,
    required String password,
    int? categoryId,
  });
}

class VodRemoteDataSourceImpl implements VodRemoteDataSource {
  final ApiClient apiClient;

  VodRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Category>> getCategories({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    final url = '$baseUrl/player_api.php?username=$username&password=$password&action=get_vod_categories';
    
    final response = await apiClient.dio.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Category(
        id: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
        name: json['category_name'] ?? 'Unknown',
        type: 'vod',
      )).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Failed to load VOD categories',
      );
    }
  }

  @override
  Future<List<MovieModel>> getMovies({
    required String baseUrl,
    required String username,
    required String password,
    int? categoryId,
  }) async {
    String url = '$baseUrl/player_api.php?username=$username&password=$password&action=get_vod_streams';
    
    if (categoryId != null) {
      url += '&category_id=$categoryId';
    }
    
    final response = await apiClient.dio.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => MovieModel.fromJson(
        json,
        baseUrl: baseUrl,
        username: username,
        password: password,
      )).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Failed to load movies',
      );
    }
  }
}
