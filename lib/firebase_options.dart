import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Placeholder Firebase config.
///
/// Replace these values by running `flutterfire configure` or pass them via
/// `--dart-define`s (e.g. `--dart-define=FIREBASE_API_KEY=abc`). The defaults
/// keep the app bootstrappable for local UI work even before real credentials
/// are available.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return kIsWeb ? web : appleAndroid;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyCu3Khzn_qK-NCmkN0EygI3BlRx7J9hAGc',
    ),
    appId: String.fromEnvironment(
      'FIREBASE_APP_ID',
      defaultValue: '1:101489429841:web:9d719d52451c514b33d770',
    ),
    messagingSenderId: String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: '101489429841',
    ),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID',
        defaultValue: 'qkomo-prod'),
    authDomain: String.fromEnvironment(
      'FIREBASE_AUTH_DOMAIN',
      defaultValue: 'qkomo-prod.firebaseapp.com',
    ),
    storageBucket: String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: 'qkomo-prod.firebasestorage.app',
    ),
    measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID',
        defaultValue: 'G-PLACEHOLDER'),
  );

  static const FirebaseOptions appleAndroid = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY',
        defaultValue: 'AIzaSyAnyYYQdCGEB2bclw-jibAO5dd7v7Vm83Q'),
    appId: String.fromEnvironment(
      'FIREBASE_APP_ID',
      defaultValue: '1:101489429841:android:e1982629f39c2c6333d770',
    ),
    messagingSenderId: String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: '101489429841',
    ),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID',
        defaultValue: 'qkomo-prod'),
    storageBucket: String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: 'qkomo-prod.firebasestorage.app',
    ),
    iosClientId: String.fromEnvironment('FIREBASE_IOS_CLIENT_ID'),
    iosBundleId: String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID',
        defaultValue: 'com.qkomo.app'),
    androidClientId: String.fromEnvironment('FIREBASE_ANDROID_CLIENT_ID'),
  );
}
