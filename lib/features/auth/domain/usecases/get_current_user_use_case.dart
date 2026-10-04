import '../entities/usuario_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UsuarioEntity?> call() {
    return repository.getSavedUser();
  }

  Future<bool> isAuthenticated() {
    return repository.isAuthenticated();
  }
}
