import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:qkomo_ui/features/auth/application/secure_token_store.dart';

/// Dio interceptor that automatically adds Firebase ID token to all requests
/// and handles token refresh on 401 responses.
class FirebaseTokenInterceptor extends Interceptor {
  FirebaseTokenInterceptor({
    required SecureTokenStore tokenStore,
    required FirebaseAuth auth,
    required Dio dioClient,
  })  : _tokenStore = tokenStore,
        _auth = auth,
        _dio = dioClient;

  final SecureTokenStore _tokenStore;
  final FirebaseAuth _auth;
  final Dio _dio;

  /// Public endpoints that don't require authentication
  static const _publicEndpoints = {
    '/api/features',
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    try {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        // No token available - log but continue (some endpoints may not require auth)
        debugPrint('⚠️ No Firebase token available for request: ${options.method} ${options.uri}');
      }
      handler.next(options);
    } catch (e) {
      // Log error but don't reject - let the backend return 401 if auth is required
      debugPrint('⚠️ Error getting Firebase token: $e. Proceeding without auth header.');
      handler.next(options);
    }
  }

  /// Check if endpoint is public (doesn't require authentication)
  bool _isPublicEndpoint(String path) {
    return _publicEndpoints.contains(path);
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
          final response = await _dio.fetch(options);
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
    var token = await _tokenStore.readToken();

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
