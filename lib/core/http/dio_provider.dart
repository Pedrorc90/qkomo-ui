import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/config/app_constants.dart';
import 'package:qkomo_ui/config/env.dart';
import 'package:qkomo_ui/core/http/firebase_token_interceptor.dart';
import 'package:qkomo_ui/core/http/retry_notification_interceptor.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';

final apiBaseUrlProvider = Provider<String>((ref) => EnvConfig.baseUrl);

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final tokenStore = ref.watch(secureTokenStoreProvider);
  final auth = ref.watch(firebaseAuthProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: AppConstants.apiConnectTimeout,
      receiveTimeout: AppConstants.apiReceiveTimeout,
    ),
  );

  // Add Firebase token interceptor for automatic authentication
  dio.interceptors.add(
    FirebaseTokenInterceptor(
      tokenStore: tokenStore,
      auth: auth,
      dioClient: dio,
    ),
  );

  // Add notification interceptor to inform user about retries
  // DEBE estar ANTES del RetryInterceptor para capturar los errores antes del retry
  dio.interceptors.add(
    RetryNotificationInterceptor(ref: ref),
  );

  // Add retry interceptor with exponential backoff
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      retryDelays: const [
        Duration(seconds: 1), // Primer reintento después de 1s
        Duration(seconds: 2), // Segundo reintento después de 2s
        Duration(seconds: 4), // Tercer reintento después de 4s
      ],
      retryableExtraStatuses: {408, 429}, // Request Timeout y Too Many Requests
    ),
  );

  return dio;
});
