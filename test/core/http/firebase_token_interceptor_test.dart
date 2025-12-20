import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qkomo_ui/core/http/firebase_token_interceptor.dart';
import 'package:qkomo_ui/features/auth/application/secure_token_store.dart';

// Manual fakes
class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  final User? _user;
  FakeFirebaseAuth(this._user);

  @override
  User? get currentUser => _user;
}

class FakeUser extends Fake implements User {
  final String _token;
  FakeUser(this._token);

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async {
    return _token;
  }
}

class FakeSecureTokenStore implements SecureTokenStore {
  String? token;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> save(String? token) async {
    this.token = token;
  }

  @override
  Future<void> clear() async {
    token = null;
  }
}

void main() {
  late FakeSecureTokenStore fakeStore;

  setUp(() {
    fakeStore = FakeSecureTokenStore();
  });

  group('FirebaseTokenInterceptor', () {
    test('Successful token retrieval from store integration', () async {
      fakeStore.token = 'cached-token';
      // Mock auth that returns nothing, ensuring we use store
      final dio = Dio();
      final interceptor = FirebaseTokenInterceptor(
        tokenStore: fakeStore,
        auth: FakeFirebaseAuth(null),
        dioClient: dio,
      );

      dio.interceptors.add(interceptor);

      // Mock the adapter to stop network
      dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBox(
          data: {'ok': true},
          statusCode: 200,
          headers: options.headers, // Echo headers
        );
      });

      final response = await dio.get('/test');

      // Verify header was added
      expect(response.requestOptions.headers['Authorization'],
          'Bearer cached-token');
    });

    test('Falls back to FirebaseAuth when store is empty', () async {
      fakeStore.token = null;
      final fakeUser = FakeUser('fresh-token');
      final fakeAuth = FakeFirebaseAuth(fakeUser);

      final dio = Dio();
      final interceptor = FirebaseTokenInterceptor(
        tokenStore: fakeStore,
        auth: fakeAuth,
        dioClient: dio,
      );

      dio.interceptors.add(interceptor);
      dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBox(
          data: {'ok': true},
          statusCode: 200,
          headers: options.headers,
        );
      });

      final response = await dio.get('/test');

      // Verify header
      expect(response.requestOptions.headers['Authorization'],
          'Bearer fresh-token');

      // Verify it was cached
      expect(fakeStore.token, 'fresh-token');
    });
  });
}

// Simple Mock Adapter for Dio
typedef MockHandler = ResponseBox Function(RequestOptions options);

class ResponseBox {
  final dynamic data;
  final int statusCode;
  final Map<String, dynamic> headers;

  ResponseBox(
      {required this.data, required this.statusCode, required this.headers});
}

class _MockAdapter implements HttpClientAdapter {
  final MockHandler _handler;

  _MockAdapter(this._handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final box = _handler(options);

    return ResponseBody.fromString(
      jsonEncode(box.data), // Encode Map to JSON string
      box.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
