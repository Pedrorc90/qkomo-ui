import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/application/secure_token_store.dart';

/// Dio interceptor that automatically adds Firebase ID token to all requests
/// and handles token refresh on 401 responses.
class FirebaseTokenInterceptor extends Interceptor {
  FirebaseTokenInterceptor({
    required SecureTokenStore tokenStore,
    required FirebaseAuth auth,
  })  : _tokenStore = tokenStore,
        _auth = auth;

  final SecureTokenStore _tokenStore;
  final FirebaseAuth _auth;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'No se pudo obtener el token de autenticación: $e',
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized by refreshing token and retrying
    if (err.response?.statusCode == 401) {
      try {
        // Refresh the token
        final newToken = await _refreshToken();
        if (newToken == null || newToken.isEmpty) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: 'Sesión expirada. Por favor, inicia sesión nuevamente.',
              type: DioExceptionType.badResponse,
              response: err.response,
            ),
          );
          return;
        }

        // Retry the request with the new token
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await Dio().fetch(options);
          handler.resolve(response);
        } catch (e) {
          handler.reject(err);
        }
      } catch (e) {
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Error al refrescar el token: $e',
            type: DioExceptionType.badResponse,
            response: err.response,
          ),
        );
      }
    } else {
      handler.next(err);
    }
  }

  /// Get token from secure storage, or fall back to Firebase Auth
  Future<String?> _getToken() async {
    // Try to get cached token from secure storage
    String? token = await _tokenStore.readToken();

    // If no cached token, try to get fresh token from Firebase Auth
    if (token == null || token.isEmpty) {
      final user = _auth.currentUser;
      if (user != null) {
        token = await user.getIdToken();
        // Cache the token for future use
        if (token != null) {
          await _tokenStore.save(token);
        }
      }
    }

    return token;
  }

  /// Refresh the Firebase ID token
  Future<String?> _refreshToken() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    // Force refresh the token
    final token = await user.getIdToken(true);

    // Save the new token to secure storage
    if (token != null) {
      await _tokenStore.save(token);
    }

    return token;
  }
}
