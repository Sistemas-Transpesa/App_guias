import '../../domain/entities/config_entity.dart';
import '../../domain/entities/guia_entity.dart';
import '../../domain/entities/sunat_mensaje_entity.dart';
import '../../domain/repositories/guias_repository.dart';
import '../datasources/guias_remote_data_source.dart';
import '../models/guia_request_model.dart';

class GuiasRepositoryImpl implements GuiasRepository {
  final GuiasRemoteDataSource remoteDataSource;

  GuiasRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<GuiaEntity>> getGuias({required String idProgramacion}) async {
    final models = await remoteDataSource.getGuias(idProgramacion: idProgramacion);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ClienteConfigEntity> getConfiguracion({
    required String idProgramacion,
    String? idCliente,
  }) async {
    final model = await remoteDataSource.getConfiguracion(
      idProgramacion: idProgramacion,
      idCliente: idCliente,
    );
    return model.toEntity();
  }

  @override
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
  }) async {
    final request = GuiaRequestModel(
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

    final model = await remoteDataSource.emitirGuia(request);
    return model.toEntity();
  }

  @override
  Future<SunatMensajeEntity> getSunatMensaje({required String idGuia}) async {
    final model = await remoteDataSource.getSunatMensaje(idGuia: idGuia);
    return model.toEntity();
  }

  @override
  Future<String> downloadPdf({
    required String idGuia,
    required String numeroGuia,
  }) {
    return remoteDataSource.downloadPdf(
      idGuia: idGuia,
      numeroGuia: numeroGuia,
    );
  }
}
