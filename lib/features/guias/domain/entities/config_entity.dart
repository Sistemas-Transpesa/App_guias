import 'package:equatable/equatable.dart';

class ClienteConfigEntity extends Equatable {
  final String idCliente;
  final String razonSocial;
  final String ruc;
  final List<RemitenteConfigEntity> remitentes;

  const ClienteConfigEntity({
    required this.idCliente,
    required this.razonSocial,
    required this.ruc,
    this.remitentes = const [],
  });

  @override
  List<Object?> get props => [idCliente, razonSocial, ruc, remitentes];
}

class RemitenteConfigEntity extends Equatable {
  final String idRemitente;
  final String razonSocial;
  final String ruc;
  final List<DestinatarioConfigEntity> destinatarios;

  const RemitenteConfigEntity({
    required this.idRemitente,
    required this.razonSocial,
    required this.ruc,
    this.destinatarios = const [],
  });

  @override
  List<Object?> get props => [idRemitente, razonSocial, ruc, destinatarios];
}

class DestinatarioConfigEntity extends Equatable {
  final String idDestinatario;
  final String razonSocial;
  final String ruc;
  final List<DireccionPartidaConfigEntity> direccionesPartida;

  const DestinatarioConfigEntity({
    required this.idDestinatario,
    required this.razonSocial,
    required this.ruc,
    this.direccionesPartida = const [],
  });

  @override
  List<Object?> get props => [idDestinatario, razonSocial, ruc, direccionesPartida];
}

class DireccionPartidaConfigEntity extends Equatable {
  final String idDireccionPartida;
  final String direccion;
  final String ubigeo;
  final List<DireccionDestinoConfigEntity> direccionesDestino;

  const DireccionPartidaConfigEntity({
    required this.idDireccionPartida,
    required this.direccion,
    required this.ubigeo,
    this.direccionesDestino = const [],
  });

  @override
  List<Object?> get props => [idDireccionPartida, direccion, ubigeo, direccionesDestino];
}

class DireccionDestinoConfigEntity extends Equatable {
  final String idDireccionDestino;
  final String direccion;
  final String ubigeo;

  const DireccionDestinoConfigEntity({
    required this.idDireccionDestino,
    required this.direccion,
    required this.ubigeo,
  });

  @override
  List<Object?> get props => [idDireccionDestino, direccion, ubigeo];
}
