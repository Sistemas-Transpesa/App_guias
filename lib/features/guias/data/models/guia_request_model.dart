import '../../domain/entities/guia_entity.dart';
import 'guia_model.dart';

class GuiaRequestModel {
  final String idProgramacion;
  final String idRemitente;
  final String idDestinatario;
  final String idDireccionPartida;
  final String idDireccionDestino;
  final double pesoTotalKg;
  final bool isTicketMode;
  final List<DocumentoRelacionadoEntity> documentos;
  final String? observacion;

  const GuiaRequestModel({
    required this.idProgramacion,
    required this.idRemitente,
    required this.idDestinatario,
    required this.idDireccionPartida,
    required this.idDireccionDestino,
    required this.pesoTotalKg,
    required this.isTicketMode,
    required this.documentos,
    this.observacion,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_programacion': idProgramacion,
      'id_remitente': idRemitente,
      'id_destinatario': idDestinatario,
      'id_direccion_partida': idDireccionPartida,
      'id_direccion_destino': idDireccionDestino,
      'peso_total_kg': pesoTotalKg,
      'es_ticket': isTicketMode ? 1 : 0,
      'documentos_relacionados': documentos.map((d) {
        if (d is DocumentoRelacionadoModel) {
          return d.toJson();
        }
        return {
          'id': d.id,
          'tipo_documento': d.tipoDocumento,
          'serie': d.serie,
          'numero': d.numero,
          'peso_kg': d.pesoKg,
        };
      }).toList(),
      'observacion': observacion ?? '',
    };
  }
}
