import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/config/app_constants.dart';
import 'package:qkomo_ui/config/env.dart';
import 'package:qkomo_ui/core/http/firebase_token_interceptor.dart';
import 'package:qkomo_ui/core/http/logging_interceptor.dart';
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
      // sendTimeout not configured to avoid Web compatibility issues
      // (sendTimeout requires request body on Web platform)
    ),
  );

  // Enforce HTTPS for non-local environments
  if (EnvConfig.environment != Environment.local && !baseUrl.startsWith('https://')) {
    throw Exception('Security Error: API calls MUST use HTTPS in ${EnvConfig.appEnv}');
  }

  // TODO: Implement Certificate Pinning with real fingerprints for production
  // This requires the SHA-256 fingerprint of the server's SSL certificate.
  // if (EnvConfig.environment == Environment.prod) {
  //   dio.interceptors.add(CertificatePinningInterceptor(allowedFingerprints: ['...']));
  // }

  // Add logging interceptor FIRST to log all requests/responses/errors
  dio.interceptors.add(LoggingInterceptor());

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

  // Add retry interceptor with single retry
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      retries: 1, // Only 1 retry attempt
      retryDelays: const [
        Duration(seconds: 1), // Single retry after 1s
      ],
      retryableExtraStatuses: {408, 429}, // Request Timeout y Too Many Requests
    ),
  );

  return dio;
});
