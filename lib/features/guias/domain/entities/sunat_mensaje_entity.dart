import 'package:equatable/equatable.dart';

class SunatMensajeEntity extends Equatable {
  final String idGuia;
  final String codigo;
  final String mensaje;
  final String? observacion;
  final String? fechaRespuesta;

  const SunatMensajeEntity({
    required this.idGuia,
    required this.codigo,
    required this.mensaje,
    this.observacion,
    this.fechaRespuesta,
  });

  @override
  List<Object?> get props => [idGuia, codigo, mensaje, observacion, fechaRespuesta];
}
