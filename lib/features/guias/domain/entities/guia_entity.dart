import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class GuiaEntity extends Equatable {
  final String id;
  final String idProgramacion;
  final String serie;
  final String numero;
  final String? fechaEmision;
  final String? remitenteRuc;
  final String? remitenteRazonSocial;
  final String? destinatarioRuc;
  final String? destinatarioRazonSocial;
  final String? direccionPartida;
  final String? ubigeoPartida;
  final String? direccionDestino;
  final String? ubigeoDestino;
  final double pesoBrutoTotal;
  final String unidadMedida;
  final String estadoSunat;
  final String? pdfUrl;
  final String? mensajeSunat;
  final List<DocumentoRelacionadoEntity> documentosRelacionados;

  const GuiaEntity({
    required this.id,
    required this.idProgramacion,
    required this.serie,
    required this.numero,
    this.fechaEmision,
    this.remitenteRuc,
    this.remitenteRazonSocial,
    this.destinatarioRuc,
    this.destinatarioRazonSocial,
    this.direccionPartida,
    this.ubigeoPartida,
    this.direccionDestino,
    this.ubigeoDestino,
    this.pesoBrutoTotal = 0.0,
    this.unidadMedida = 'KGM',
    required this.estadoSunat,
    this.pdfUrl,
    this.mensajeSunat,
    this.documentosRelacionados = const [],
  });

  String get numeroCompleto => '$serie-$numero';

  bool get isAceptado =>
      estadoSunat.toUpperCase() == AppConstants.sunatAceptado;

  bool get isRechazado =>
      estadoSunat.toUpperCase() == AppConstants.sunatRechazado;

  bool get isPendiente =>
      estadoSunat.toUpperCase() == AppConstants.sunatPendiente ||
      (!isAceptado && !isRechazado);

  @override
  List<Object?> get props => [
        id,
        idProgramacion,
        serie,
        numero,
        fechaEmision,
        remitenteRuc,
        remitenteRazonSocial,
        destinatarioRuc,
        destinatarioRazonSocial,
        direccionPartida,
        ubigeoPartida,
        direccionDestino,
        ubigeoDestino,
        pesoBrutoTotal,
        unidadMedida,
        estadoSunat,
        pdfUrl,
        mensajeSunat,
        documentosRelacionados,
      ];
}

class DocumentoRelacionadoEntity extends Equatable {
  final String id;
  final String tipoDocumento; // "GUIA_REMITENTE" o "TICKET"
  final String serie;
  final String numero;
  final double pesoKg;

  const DocumentoRelacionadoEntity({
    required this.id,
    required this.tipoDocumento,
    required this.serie,
    required this.numero,
    required this.pesoKg,
  });

  String get identificador => '$serie-$numero';

  @override
  List<Object?> get props => [id, tipoDocumento, serie, numero, pesoKg];
}
