import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/http/retry_state_notifier.dart';

/// Interceptor para notificar al usuario cuando se están haciendo reintentos
class RetryNotificationInterceptor extends Interceptor {
  final Ref ref;

  RetryNotificationInterceptor({required this.ref});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Inicializar el contador de reintentos si no existe
    if (!options.extra.containsKey('_retry_count')) {
      options.extra['_retry_count'] = 0;
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Incrementar el contador de reintentos
    final currentRetryCount =
        (err.requestOptions.extra['_retry_count'] as int?) ?? 0;

    // Si es un error que causará un reintento, incrementar el contador
    if (_shouldRetry(err)) {
      final newRetryCount = currentRetryCount + 1;
      err.requestOptions.extra['_retry_count'] = newRetryCount;

      // Notificar al usuario que se está reintentando
      if (newRetryCount > 0 && newRetryCount <= 3) {
        debugPrint('Reintentando conexión (intento $newRetryCount de 3)...');
        ref.read(retryStateProvider.notifier).startRetry(newRetryCount);
      }
    }

    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Cuando hay una respuesta exitosa, limpiar el estado de reintentos
    final retryCount =
        response.requestOptions.extra['_retry_count'] as int? ?? 0;
    if (retryCount > 0) {
      debugPrint('Conexión restablecida después de $retryCount reintento(s)');
    }
    ref.read(retryStateProvider.notifier).endRetry();
    super.onResponse(response, handler);
  }

  /// Determina si el error debe causar un reintento
  bool _shouldRetry(DioException err) {
    // Reintentar en errores de conexión, timeout, y respuestas 5xx
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
