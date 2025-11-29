import 'package:dio/dio.dart';

/// Centralized error messages for capture operations in Spanish.
class CaptureErrorMessages {
  // Network errors
  static const networkError =
      'No hay conexión. La captura se guardó y se procesará cuando vuelva la conexión.';

  // Authentication errors
  static const authError =
      'Sesión expirada. Por favor, inicia sesión nuevamente.';

  // Server errors
  static const serverError =
      'Error del servidor. Intenta de nuevo más tarde.';

  // Validation errors
  static const invalidImageFormat =
      'Formato de imagen no válido. Usa JPG o PNG.';
  static const fileTooLarge = 'La imagen es demasiado grande. Máximo 10MB.';
  static const missingImage = 'Falta la imagen para procesar.';
  static const missingBarcode = 'Falta el código de barras para procesar.';

  // Product errors
  static const productNotFound =
      'Producto no encontrado. Intenta con otro código de barras.';

  // Generic errors
  static const unknownError = 'Error al procesar la captura.';

  /// Get user-friendly error message from exception
  static String fromException(dynamic error) {
    if (error is DioException) {
      return _fromDioException(error);
    }

    if (error is String) {
      return error;
    }

    if (error is Exception) {
      final message = error.toString();
      if (message.contains('imagen')) return invalidImageFormat;
      if (message.contains('barcode') || message.contains('código')) {
        return missingBarcode;
      }
      if (message.contains('autenticado') || message.contains('token')) {
        return authError;
      }
    }

    return unknownError;
  }

  /// Get user-friendly error message from DioException
  static String _fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return networkError;

      case DioExceptionType.connectionError:
        return networkError;

      case DioExceptionType.badResponse:
        return _fromHttpStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Operación cancelada.';

      case DioExceptionType.badCertificate:
        return 'Error de certificado de seguridad.';

      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return networkError;
        }
        return unknownError;
    }
  }

  /// Get user-friendly error message from HTTP status code
  static String _fromHttpStatusCode(int? statusCode) {
    if (statusCode == null) return serverError;

    switch (statusCode) {
      case 400:
        return 'Solicitud inválida. Verifica los datos enviados.';
      case 401:
        return authError;
      case 403:
        return 'No tienes permiso para realizar esta acción.';
      case 404:
        return productNotFound;
      case 413:
        return fileTooLarge;
      case 415:
        return invalidImageFormat;
      case 429:
        return 'Demasiadas solicitudes. Intenta de nuevo en unos momentos.';
      case 500:
      case 502:
      case 503:
      case 504:
        return serverError;
      default:
        if (statusCode >= 400 && statusCode < 500) {
          return 'Error en la solicitud. Intenta de nuevo.';
        }
        if (statusCode >= 500) {
          return serverError;
        }
        return unknownError;
    }
  }

  /// Check if error is a network connectivity issue
  static bool isNetworkError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          (error.type == DioExceptionType.unknown &&
              error.error.toString().contains('SocketException'));
    }
    return false;
  }

  /// Check if error is an authentication issue
  static bool isAuthError(dynamic error) {
    if (error is DioException) {
      return error.response?.statusCode == 401;
    }
    if (error is String) {
      return error.contains('autenticado') || error.contains('token');
    }
    return false;
  }

  /// Check if error is retryable
  static bool isRetryable(dynamic error) {
    if (isNetworkError(error)) return true;
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      // Retry on server errors (5xx) and rate limiting (429)
      return statusCode != null &&
          (statusCode >= 500 || statusCode == 429 || statusCode == 408);
    }
    return false;
  }
}
