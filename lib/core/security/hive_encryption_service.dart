import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class HiveEncryptionService {
  static const _encryptionKeyName = 'hive_encryption_key';

  final FlutterSecureStorage _storage;

  HiveEncryptionService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              mOptions: MacOsOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  /// Retrieves the encryption key from secure storage, or generates a new one.
  Future<Uint8List> getEncryptionKey() async {
    final containsEncryptionKey = await _storage.containsKey(key: _encryptionKeyName);

    if (!containsEncryptionKey) {
      final key = Hive.generateSecureKey();
      await _storage.write(
        key: _encryptionKeyName,
        value: base64Url.encode(key),
      );
    }

    final keyString = await _storage.read(key: _encryptionKeyName);
    return Uint8List.fromList(base64Url.decode(keyString!));
  }
}
