import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/api_constants.dart';

class ApiClient {
  late Dio _dio;
  late CacheOptions _cacheOptions;
  final String? Function()? _authCredentials;

  ApiClient({String? Function()? authCredentials})
      : _authCredentials = authCredentials {
    _initDio();
  }

  Future<void> _initDio() async {
    // Configure cache options
    final cacheDir = await getTemporaryDirectory();
    _cacheOptions = CacheOptions(
      store: FileCacheStore(cacheDir.path),
      policy: CachePolicy.requestCacheFirst,
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );

    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: ApiConstants.defaultTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.defaultTimeout),
        sendTimeout: const Duration(milliseconds: ApiConstants.defaultTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth credentials to request
          if (_authCredentials != null) {
            final credentials = _authCredentials!();
            if (credentials != null) {
              final separator = options.path.contains('?') ? '&' : '?';
              options.path = '${options.path}$separator$credentials';
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );

    // Add cache interceptor
    _dio.interceptors.add(DioCacheInterceptor(options: _cacheOptions));

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) {
          // In production, use a proper logger
          // ignore: avoid_print
          print(obj);
        },
      ),
    );
  }

  Dio get dio => _dio;

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void setAuthCredentials(String username, String password) {
    // Update credentials provider
    // Note: This is handled externally now via constructor
  }

  /// Enable or disable caching
  void setCachingEnabled(bool enabled) {
    _dio.interceptors.removeWhere((interceptor) => interceptor is DioCacheInterceptor);
    if (enabled) {
      _dio.interceptors.add(DioCacheInterceptor(options: _cacheOptions));
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    final store = _cacheOptions.store;
    if (store != null) {
      await store.clean();
    }
  }

  /// Get cached response if available
  Future<Response?> getCached(String path) async {
    final options = _cacheOptions.copyWith(
      policy: CachePolicy.cacheFirst,
    );
    try {
      return await _dio.get(path, options: options);
    } catch (_) {
      return null;
    }
  }

  /// Force refresh (bypass cache)
  Future<Response> forceRefresh(String path, {Map<String, dynamic>? queryParameters}) async {
    final options = _cacheOptions.copyWith(
      policy: CachePolicy.refresh,
    );
    return await _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool forceRefresh = false,
  }) async {
    final options = _cacheOptions.copyWith(
      policy: forceRefresh ? CachePolicy.refresh : CachePolicy.requestCacheFirst,
    );
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }
}

/// Pagination helper class
class PaginationParams {
  final int page;
  final int limit;

  const PaginationParams({
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
    };
  }
}

/// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasMore;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  }) : hasMore = currentPage < totalPages;
}
