import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> authenticate({
    required String baseUrl,
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> authenticate({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    final url = '$baseUrl/player_api.php?username=$username&password=$password';
    
    final response = await apiClient.dio.get(url);
    
    if (response.statusCode == 200) {
      return UserModel.fromJson(
        response.data,
        baseUrl: baseUrl,
        username: username,
        password: password,
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Authentication failed',
      );
    }
  }
}
