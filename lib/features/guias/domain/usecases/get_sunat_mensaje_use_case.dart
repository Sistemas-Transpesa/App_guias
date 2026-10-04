import '../entities/sunat_mensaje_entity.dart';
import '../repositories/guias_repository.dart';

class GetSunatMensajeUseCase {
  final GuiasRepository repository;

  GetSunatMensajeUseCase(this.repository);

  Future<SunatMensajeEntity> call({required String idGuia}) {
    return repository.getSunatMensaje(idGuia: idGuia);
  }
}
