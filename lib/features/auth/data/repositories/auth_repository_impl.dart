import 'dart:convert';
import '../../../../core/storage/preferences_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/usuario_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorage;
  final PreferencesService preferencesService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
    required this.preferencesService,
  });

  @override
  Future<UsuarioEntity> login({
    required String username,
    required String password,
  }) async {
    final usuarioModel = await remoteDataSource.login(
      username: username,
      password: password,
    );

    // Save token & reference securely
    if (usuarioModel.token != null && usuarioModel.token!.isNotEmpty) {
      await secureStorage.saveToken(usuarioModel.token!);
    }
    if (usuarioModel.reference != null && usuarioModel.reference!.isNotEmpty) {
      await secureStorage.saveReference(usuarioModel.reference!);
    }

    // Save full user model JSON securely
    await secureStorage.saveUserJson(jsonEncode(usuarioModel.toJson()));

    return usuarioModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await secureStorage.clearAll();
  }

  @override
  Future<UsuarioEntity?> getSavedUser() async {
    final jsonStr = await secureStorage.getUserJson();
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UsuarioModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.getToken();
    return token != null && token.trim().isNotEmpty;
  }

  @override
  Future<void> saveRememberUsername(String username) async {
    await preferencesService.setRememberUsername(username);
  }

  @override
  String? getRememberUsername() {
    return preferencesService.getRememberUsername();
  }
}
