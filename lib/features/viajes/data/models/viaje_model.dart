import '../../domain/entities/viaje_entity.dart';

class ViajeModel extends ViajeEntity {
  const ViajeModel({
    required super.idProgramacion,
    required super.codViaje,
    required super.ruta,
    required super.cliente,
    required super.tracto,
    required super.carreta,
    required super.conductor,
    super.dniConductor,
    super.rucCliente,
    required super.fecha,
    super.idTipo,
    super.observacion,
    super.estado,
  });

  factory ViajeModel.fromJson(Map<String, dynamic> json) {
    return ViajeModel(
      idProgramacion: (json['IDPROGRAMACION'] ?? json['idProgramacion'] ?? json['id_programacion'] ?? json['id'] ?? '').toString(),
      codViaje: (json['CODVIAJE'] ?? json['codViaje'] ?? json['cod_viaje'] ?? json['codigo'] ?? '').toString(),
      ruta: (json['RUTA'] ?? json['ruta'] ?? 'Sin Ruta Asignada').toString(),
      cliente: (json['CLIENTE'] ?? json['cliente'] ?? json['razon_social'] ?? 'Cliente General').toString(),
      tracto: (json['TRACTO'] ?? json['tracto'] ?? json['placa_tracto'] ?? '-').toString(),
      carreta: (json['CARRETA'] ?? json['carreta'] ?? json['placa_carreta'] ?? '-').toString(),
      conductor: (json['CONDUCTOR'] ?? json['conductor'] ?? json['nombre_conductor'] ?? '-').toString(),
      dniConductor: (json['DNICONDUCTOR'] ?? json['dniConductor'] ?? json['dni_conductor'] ?? json['DNI'])?.toString(),
      rucCliente: (json['RUCCLIENTE'] ?? json['rucCliente'] ?? json['ruc_cliente'] ?? json['RUC'])?.toString(),
      fecha: (json['FECHA'] ?? json['fecha'] ?? json['FECHAPROGRAMADA'] ?? json['fecha_programada'] ?? '').toString(),
      idTipo: (json['IDTIPO'] ?? json['idTipo'] ?? json['id_tipo'] ?? '0').toString(),
      observacion: (json['OBSERVACION'] ?? json['observacion'])?.toString(),
      estado: (json['ESTADO'] ?? json['estado'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IDPROGRAMACION': idProgramacion,
      'CODVIAJE': codViaje,
      'RUTA': ruta,
      'CLIENTE': cliente,
      'TRACTO': tracto,
      'CARRETA': carreta,
      'CONDUCTOR': conductor,
      'DNICONDUCTOR': dniConductor,
      'RUCCLIENTE': rucCliente,
      'FECHA': fecha,
      'IDTIPO': idTipo,
      'OBSERVACION': observacion,
      'ESTADO': estado,
    };
  }

  ViajeEntity toEntity() => this;
}
