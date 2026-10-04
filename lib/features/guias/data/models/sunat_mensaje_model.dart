import '../../domain/entities/sunat_mensaje_entity.dart';

class SunatMensajeModel extends SunatMensajeEntity {
  const SunatMensajeModel({
    required super.idGuia,
    required super.codigo,
    required super.mensaje,
    super.observacion,
    super.fechaRespuesta,
  });

  factory SunatMensajeModel.fromJson(Map<String, dynamic> json) {
    return SunatMensajeModel(
      idGuia: (json['id_guia'] ?? json['id'] ?? '').toString(),
      codigo: (json['codigo'] ?? json['codigo_respuesta'] ?? json['codigo_sunat'] ?? '0').toString(),
      mensaje: (json['mensaje'] ?? json['descripcion'] ?? json['mensaje_sunat'] ?? 'Sin mensaje de SUNAT').toString(),
      observacion: (json['observacion'] ?? json['detalles'])?.toString(),
      fechaRespuesta: (json['fecha_respuesta'] ?? json['fecha'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_guia': idGuia,
      'codigo': codigo,
      'mensaje': mensaje,
      'observacion': observacion,
      'fecha_respuesta': fechaRespuesta,
    };
  }

  SunatMensajeEntity toEntity() => this;
}
