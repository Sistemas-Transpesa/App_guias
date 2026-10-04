import '../entities/usuario_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UsuarioEntity> call({
    required String username,
    required String password,
  }) {
    return repository.login(username: username, password: password);
  }
}
