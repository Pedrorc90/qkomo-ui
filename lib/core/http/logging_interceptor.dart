import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor to log all HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  static int _requestIdCounter = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Generate unique request ID
    final requestId = ++_requestIdCounter;
    options.extra['_request_id'] = requestId;

    final isSilent = options.extra['silent_request'] as bool? ?? false;
    final silentTag = isSilent ? '[SILENT]' : '[VISIBLE]';
    debugPrint('➡️ [$requestId] $silentTag ${options.method} ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestId = response.requestOptions.extra['_request_id'] ?? '?';
    final isSilent = response.requestOptions.extra['silent_request'] as bool? ?? false;
    final silentTag = isSilent ? '[SILENT]' : '[VISIBLE]';
    debugPrint(
        '✅ [$requestId] $silentTag ${response.requestOptions.method} ${response.requestOptions.uri} - ${response.statusCode}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestId = err.requestOptions.extra['_request_id'] ?? '?';
    final isSilent = err.requestOptions.extra['silent_request'] as bool? ?? false;
    final silentTag = isSilent ? '[SILENT]' : '[VISIBLE]';
    final statusCode = err.response?.statusCode ?? 'N/A';
    debugPrint(
        '❌ [$requestId] $silentTag ${err.requestOptions.method} ${err.requestOptions.path} - $statusCode - (${err.type}) 🔍 ${err.message})');

    super.onError(err, handler);
  }
}
