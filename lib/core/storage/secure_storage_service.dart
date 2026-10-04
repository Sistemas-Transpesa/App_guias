import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

abstract class SecureStorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  Future<void> saveReference(String reference);
  Future<String?> getReference();
  Future<void> deleteReference();

  Future<void> saveUserJson(String json);
  Future<String?> getUserJson();
  Future<void> deleteUserJson();

  Future<void> clearAll();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.keyToken, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.keyToken);
  }

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.keyToken);
  }

  @override
  Future<void> saveReference(String reference) async {
    await _storage.write(key: AppConstants.keyReference, value: reference);
  }

  @override
  Future<String?> getReference() async {
    return await _storage.read(key: AppConstants.keyReference);
  }

  @override
  Future<void> deleteReference() async {
    await _storage.delete(key: AppConstants.keyReference);
  }

  @override
  Future<void> saveUserJson(String json) async {
    await _storage.write(key: AppConstants.keyUserJson, value: json);
  }

  @override
  Future<String?> getUserJson() async {
    return await _storage.read(key: AppConstants.keyUserJson);
  }

  @override
  Future<void> deleteUserJson() async {
    await _storage.delete(key: AppConstants.keyUserJson);
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
