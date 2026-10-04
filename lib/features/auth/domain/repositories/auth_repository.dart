import '../../domain/entities/usuario_entity.dart';

abstract class AuthRepository {
  Future<UsuarioEntity> login({
    required String username,
    required String password,
  });

  Future<void> logout();

  Future<UsuarioEntity?> getSavedUser();

  Future<bool> isAuthenticated();

  Future<void> saveRememberUsername(String username);

  String? getRememberUsername();
}
