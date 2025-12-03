import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/config/env.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/core/http/firebase_token_interceptor.dart';

final apiBaseUrlProvider = Provider<String>((ref) => EnvConfig.baseUrl);

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final tokenStore = ref.watch(secureTokenStoreProvider);
  final auth = ref.watch(firebaseAuthProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // Add Firebase token interceptor for automatic authentication
  dio.interceptors.add(
    FirebaseTokenInterceptor(
      tokenStore: tokenStore,
      auth: auth,
    ),
  );

  return dio;
});
