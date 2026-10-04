import '../../domain/entities/guia_entity.dart';

class GuiaModel extends GuiaEntity {
  const GuiaModel({
    required super.id,
    required super.idProgramacion,
    required super.serie,
    required super.numero,
    super.fechaEmision,
    super.remitenteRuc,
    super.remitenteRazonSocial,
    super.destinatarioRuc,
    super.destinatarioRazonSocial,
    super.direccionPartida,
    super.ubigeoPartida,
    super.direccionDestino,
    super.ubigeoDestino,
    super.pesoBrutoTotal,
    super.unidadMedida,
    required super.estadoSunat,
    super.pdfUrl,
    super.mensajeSunat,
    super.documentosRelacionados,
  });

  factory GuiaModel.fromJson(Map<String, dynamic> json) {
    var docs = <DocumentoRelacionadoEntity>[];
    final rawDocs = json['documentos_relacionados'] ??
        json['documentosRelacionados'] ??
        json['series_remitentes'] ??
        json['tickets'];

    if (rawDocs is List) {
      docs = rawDocs
          .map((d) => DocumentoRelacionadoModel.fromJson(d as Map<String, dynamic>))
          .toList();
    }

    double parseWeight(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return GuiaModel(
      id: (json['id'] ?? json['ID'] ?? json['id_guia'] ?? '').toString(),
      idProgramacion: (json['id_programacion'] ??
              json['IDPROGRAMACION'] ??
              json['idProgramacion'] ??
              '')
          .toString(),
      serie: (json['serie'] ?? json['SERIE'] ?? '').toString(),
      numero: (json['numero'] ?? json['NUMERO'] ?? '').toString(),
      fechaEmision: (json['fecha_emision'] ??
              json['FECHAEMISION'] ??
              json['fechaEmision'] ??
              json['fecha'])
          ?.toString(),
      remitenteRuc: (json['remitente_ruc'] ??
              json['RUC_REMITENTE'] ??
              json['remitenteRuc'])
          ?.toString(),
      remitenteRazonSocial: (json['remitente_razon_social'] ??
              json['REMITENTE'] ??
              json['remitente'])
          ?.toString(),
      destinatarioRuc: (json['destinatario_ruc'] ??
              json['RUC_DESTINATARIO'] ??
              json['destinatarioRuc'])
          ?.toString(),
      destinatarioRazonSocial: (json['destinatario_razon_social'] ??
              json['DESTINATARIO'] ??
              json['destinatario'])
          ?.toString(),
      direccionPartida: (json['direccion_partida'] ??
              json['DIRECCION_PARTIDA'] ??
              json['direccionPartida'])
          ?.toString(),
      ubigeoPartida: (json['ubigeo_partida'] ??
              json['UBIGEO_PARTIDA'] ??
              json['ubigeoPartida'])
          ?.toString(),
      direccionDestino: (json['direccion_destino'] ??
              json['DIRECCION_DESTINO'] ??
              json['direccionDestino'])
          ?.toString(),
      ubigeoDestino: (json['ubigeo_destino'] ??
              json['UBIGEO_DESTINO'] ??
              json['ubigeoDestino'])
          ?.toString(),
      pesoBrutoTotal: parseWeight(
          json['peso_bruto_total'] ?? json['PESOTOTAL'] ?? json['pesoTotal']),
      unidadMedida: (json['unidad_medida'] ?? json['UNIDAD'] ?? 'KGM').toString(),
      estadoSunat: (json['estado_sunat'] ??
              json['ESTADO_SUNAT'] ??
              json['estadoSunat'] ??
              json['estado'] ??
              'PENDIENTE')
          .toString(),
      pdfUrl: (json['pdf_url'] ?? json['URL_PDF'] ?? json['pdfUrl'])?.toString(),
      mensajeSunat: (json['mensaje_sunat'] ??
              json['MENSAJE_SUNAT'] ??
              json['mensajeSunat'] ??
              json['mensaje'])
          ?.toString(),
      documentosRelacionados: docs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_programacion': idProgramacion,
      'serie': serie,
      'numero': numero,
      'fecha_emision': fechaEmision,
      'remitente_ruc': remitenteRuc,
      'remitente_razon_social': remitenteRazonSocial,
      'destinatario_ruc': destinatarioRuc,
      'destinatario_razon_social': destinatarioRazonSocial,
      'direccion_partida': direccionPartida,
      'ubigeo_partida': ubigeoPartida,
      'direccion_destino': direccionDestino,
      'ubigeo_destino': ubigeoDestino,
      'peso_bruto_total': pesoBrutoTotal,
      'unidad_medida': unidadMedida,
      'estado_sunat': estadoSunat,
      'pdf_url': pdfUrl,
      'mensaje_sunat': mensajeSunat,
      'documentos_relacionados': documentosRelacionados
          .map((d) => (d as DocumentoRelacionadoModel).toJson())
          .toList(),
    };
  }

  GuiaEntity toEntity() => this;
}

class DocumentoRelacionadoModel extends DocumentoRelacionadoEntity {
  const DocumentoRelacionadoModel({
    required super.id,
    required super.tipoDocumento,
    required super.serie,
    required super.numero,
    required super.pesoKg,
  });

  factory DocumentoRelacionadoModel.fromJson(Map<String, dynamic> json) {
    double parseWeight(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return DocumentoRelacionadoModel(
      id: (json['id'] ?? json['ID'] ?? DateTime.now().millisecondsSinceEpoch.toString()).toString(),
      tipoDocumento: (json['tipo_documento'] ?? json['tipo'] ?? 'GUIA_REMITENTE').toString(),
      serie: (json['serie'] ?? json['SERIE'] ?? '').toString(),
      numero: (json['numero'] ?? json['NUMERO'] ?? '').toString(),
      pesoKg: parseWeight(json['peso_kg'] ?? json['peso'] ?? json['PESO']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo_documento': tipoDocumento,
      'serie': serie,
      'numero': numero,
      'peso_kg': pesoKg,
    };
  }

  DocumentoRelacionadoEntity toEntity() => this;
}
