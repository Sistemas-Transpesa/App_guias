import '../entities/config_entity.dart';
import '../repositories/guias_repository.dart';

class GetConfiguracionUseCase {
  final GuiasRepository repository;

  GetConfiguracionUseCase(this.repository);

  Future<ClienteConfigEntity> call({
    required String idProgramacion,
    String? idCliente,
  }) {
    return repository.getConfiguracion(
      idProgramacion: idProgramacion,
      idCliente: idCliente,
    );
  }
}
