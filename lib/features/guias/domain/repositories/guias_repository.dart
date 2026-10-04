import '../entities/config_entity.dart';
import '../entities/guia_entity.dart';
import '../entities/sunat_mensaje_entity.dart';

abstract class GuiasRepository {
  Future<List<GuiaEntity>> getGuias({required String idProgramacion});

  Future<ClienteConfigEntity> getConfiguracion({
    required String idProgramacion,
    String? idCliente,
  });

  Future<GuiaEntity> emitirGuia({
    required String idProgramacion,
    required String idRemitente,
    required String idDestinatario,
    required String idDireccionPartida,
    required String idDireccionDestino,
    required double pesoTotalKg,
    required bool isTicketMode,
    required List<DocumentoRelacionadoEntity> documentos,
    String? observacion,
  });

  Future<SunatMensajeEntity> getSunatMensaje({required String idGuia});

  Future<String> downloadPdf({
    required String idGuia,
    required String numeroGuia,
  });
}
