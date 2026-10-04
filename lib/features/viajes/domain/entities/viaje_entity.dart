import 'package:equatable/equatable.dart';

class ViajeEntity extends Equatable {
  final String idProgramacion;
  final String codViaje;
  final String ruta;
  final String cliente;
  final String tracto;
  final String carreta;
  final String conductor;
  final String? dniConductor;
  final String? rucCliente;
  final String fecha;
  final String idTipo; // "1" for Ticket Balanza mode, other for Standard
  final String? observacion;
  final String? estado;

  const ViajeEntity({
    required this.idProgramacion,
    required this.codViaje,
    required this.ruta,
    required this.cliente,
    required this.tracto,
    required this.carreta,
    required this.conductor,
    this.dniConductor,
    this.rucCliente,
    required this.fecha,
    this.idTipo = '0',
    this.observacion,
    this.estado,
  });

  bool get isTicketType => idTipo == '1';

  @override
  List<Object?> get props => [
        idProgramacion,
        codViaje,
        ruta,
        cliente,
        tracto,
        carreta,
        conductor,
        dniConductor,
        rucCliente,
        fecha,
        idTipo,
        observacion,
        estado,
      ];
}
