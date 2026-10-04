import '../entities/guia_entity.dart';
import '../repositories/guias_repository.dart';

class EmitirGuiaUseCase {
  final GuiasRepository repository;

  EmitirGuiaUseCase(this.repository);

  Future<GuiaEntity> call({
    required String idProgramacion,
    required String idRemitente,
    required String idDestinatario,
    required String idDireccionPartida,
    required String idDireccionDestino,
    required double pesoTotalKg,
    required bool isTicketMode,
    required List<DocumentoRelacionadoEntity> documentos,
    String? observacion,
  }) {
    return repository.emitirGuia(
      idProgramacion: idProgramacion,
      idRemitente: idRemitente,
      idDestinatario: idDestinatario,
      idDireccionPartida: idDireccionPartida,
      idDireccionDestino: idDireccionDestino,
      pesoTotalKg: pesoTotalKg,
      isTicketMode: isTicketMode,
      documentos: documentos,
      observacion: observacion,
    );
  }
}
