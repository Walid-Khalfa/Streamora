import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logging_interceptor.g.dart';

@Riverpod(keepAlive: true)
LoggingInterceptor loggingInterceptor(Ref ref) {
  return LoggingInterceptor();
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('➡️ REQUEST: ${options.method} ${options.uri}');
      debugPrint('Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('⬅️ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('Data: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ ERROR: ${err.type} - ${err.message}');
      debugPrint('URL: ${err.requestOptions.uri}');
      if (err.response != null) {
        debugPrint('Status: ${err.response?.statusCode}');
        debugPrint('Data: ${err.response?.data}');
      }
    }
    handler.next(err);
  }
}
