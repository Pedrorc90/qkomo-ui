import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/http/retry_state_notifier.dart';

/// Interceptor to notify the user when retries are being made
class RetryNotificationInterceptor extends Interceptor {
  RetryNotificationInterceptor({required this.ref});
  final Ref ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Initialize retry counter if it doesn't exist
    if (!options.extra.containsKey('_retry_count')) {
      options.extra['_retry_count'] = 0;
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check if the request is marked as silent
    final isSilent = err.requestOptions.extra['silent_request'] as bool? ?? false;

    // If it's a silent request, don't show retry overlay
    if (isSilent) {
      debugPrint(
          '[RetryNotificationInterceptor] Silent request to ${err.requestOptions.uri.path}, overlay will not be shown');
      super.onError(err, handler);
      return;
    }

    // Increment retry counter
    final currentRetryCount = (err.requestOptions.extra['_retry_count'] as int?) ?? 0;

    // If it's an error that will cause a retry, increment the counter
    if (_shouldRetry(err)) {
      final newRetryCount = currentRetryCount + 1;
      err.requestOptions.extra['_retry_count'] = newRetryCount;

      // Notify the user that a retry is being attempted
      if (newRetryCount > 0 && newRetryCount <= 1) {
        debugPrint('Retrying connection (attempt $newRetryCount of 1)...');
        ref.read(retryStateProvider.notifier).startRetry(newRetryCount);
      }
    } else {
      // Non-recoverable error: clear the notification
      debugPrint('Non-recoverable error (${err.type}). Clearing retry state.');
      ref.read(retryStateProvider.notifier).endRetry();
    }

    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // When there's a successful response, clear the retry state
    final retryCount = response.requestOptions.extra['_retry_count'] as int? ?? 0;
    if (retryCount > 0) {
      debugPrint('Connection restored after $retryCount retry/retries');
    }
    ref.read(retryStateProvider.notifier).endRetry();
    super.onResponse(response, handler);
  }

  /// Determines if the error should cause a retry
  bool _shouldRetry(DioException err) {
    // Retry on connection errors, timeouts, and 5xx responses
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
