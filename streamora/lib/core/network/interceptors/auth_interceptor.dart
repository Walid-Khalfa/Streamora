import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';

part 'auth_interceptor.g.dart';

@Riverpod(keepAlive: true)
AuthInterceptor authInterceptor(Ref ref) {
  return AuthInterceptor(ref);
}

class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authState = _ref.read(authNotifierProvider);
    
    authState.whenOrNull(
      authenticated: (user, credentials) {
        if (credentials != null) {
          // Add authentication parameters to query string for Xtream API
          final authParams = {
            'username': credentials.username,
            'password': credentials.password,
          };
          
          options.queryParameters.addAll(authParams);
        }
      },
    );

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized - could refresh token or logout
      _ref.read(authNotifierProvider.notifier).logout();
    }
    handler.next(err);
  }
}
