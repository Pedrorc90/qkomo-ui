import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/auth/application/auth_controller.dart';
import 'package:qkomo_ui/features/auth/application/secure_token_store.dart';
import 'package:qkomo_ui/features/profile/application/user_profile_providers.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final authInProgressProvider = StateProvider<bool>((ref) => false);

final secureTokenStoreProvider = Provider<SecureTokenStore>((ref) {
  return SecureTokenStore();
});

final idTokenProvider = FutureProvider<String?>((ref) {
  return ref.watch(secureTokenStoreProvider).readToken();
});

final authControllerProvider = Provider<AuthController>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final tokenStore = ref.watch(secureTokenStoreProvider);
  final userProfileRepo = ref.watch(userProfileRepositoryProvider);
  return AuthController(
    auth: auth,
    tokenStore: tokenStore,
    onTokenChanged: () => ref.invalidate(idTokenProvider),
    userProfileRepo: userProfileRepo,
  );
});
