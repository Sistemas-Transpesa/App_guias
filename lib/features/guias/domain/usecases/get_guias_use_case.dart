import '../entities/guia_entity.dart';
import '../repositories/guias_repository.dart';

class GetGuiasUseCase {
  final GuiasRepository repository;

  GetGuiasUseCase(this.repository);

  Future<List<GuiaEntity>> call({required String idProgramacion}) {
    return repository.getGuias(idProgramacion: idProgramacion);
  }
}
