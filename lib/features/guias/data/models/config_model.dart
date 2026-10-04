import '../../domain/entities/config_entity.dart';

class ClienteConfigModel extends ClienteConfigEntity {
  const ClienteConfigModel({
    required super.idCliente,
    required super.razonSocial,
    required super.ruc,
    super.remitentes,
  });

  factory ClienteConfigModel.fromJson(Map<String, dynamic> json) {
    var remitentesList = <RemitenteConfigModel>[];
    final rawRemitentes = json['remitentes'] ?? json['REMITENTES'] ?? json['data'];
    if (rawRemitentes is List) {
      remitentesList = rawRemitentes
          .map((r) => RemitenteConfigModel.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    return ClienteConfigModel(
      idCliente: (json['id_cliente'] ?? json['IDCLIENTE'] ?? json['id'] ?? '').toString(),
      razonSocial: (json['razon_social'] ?? json['RAZONSOCIAL'] ?? json['cliente'] ?? 'Cliente').toString(),
      ruc: (json['ruc'] ?? json['RUC'] ?? '').toString(),
      remitentes: remitentesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cliente': idCliente,
      'razon_social': razonSocial,
      'ruc': ruc,
      'remitentes': remitentes.map((r) => (r as RemitenteConfigModel).toJson()).toList(),
    };
  }

  ClienteConfigEntity toEntity() => this;
}

class RemitenteConfigModel extends RemitenteConfigEntity {
  const RemitenteConfigModel({
    required super.idRemitente,
    required super.razonSocial,
    required super.ruc,
    super.destinatarios,
  });

  factory RemitenteConfigModel.fromJson(Map<String, dynamic> json) {
    var destList = <DestinatarioConfigModel>[];
    final rawDest = json['destinatarios'] ?? json['DESTINATARIOS'];
    if (rawDest is List) {
      destList = rawDest
          .map((d) => DestinatarioConfigModel.fromJson(d as Map<String, dynamic>))
          .toList();
    }

    return RemitenteConfigModel(
      idRemitente: (json['id_remitente'] ?? json['IDREMITENTE'] ?? json['id'] ?? '').toString(),
      razonSocial: (json['razon_social'] ?? json['RAZONSOCIAL'] ?? json['remitente'] ?? '').toString(),
      ruc: (json['ruc'] ?? json['RUC'] ?? '').toString(),
      destinatarios: destList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_remitente': idRemitente,
      'razon_social': razonSocial,
      'ruc': ruc,
      'destinatarios': destinatarios.map((d) => (d as DestinatarioConfigModel).toJson()).toList(),
    };
  }
}

class DestinatarioConfigModel extends DestinatarioConfigEntity {
  const DestinatarioConfigModel({
    required super.idDestinatario,
    required super.razonSocial,
    required super.ruc,
    super.direccionesPartida,
  });

  factory DestinatarioConfigModel.fromJson(Map<String, dynamic> json) {
    var partidaList = <DireccionPartidaConfigModel>[];
    final rawPartida = json['direcciones_partida'] ??
        json['DIRECCIONES_PARTIDA'] ??
        json['partidas'];
    if (rawPartida is List) {
      partidaList = rawPartida
          .map((p) => DireccionPartidaConfigModel.fromJson(p as Map<String, dynamic>))
          .toList();
    }

    return DestinatarioConfigModel(
      idDestinatario: (json['id_destinatario'] ?? json['IDDESTINATARIO'] ?? json['id'] ?? '').toString(),
      razonSocial: (json['razon_social'] ?? json['RAZONSOCIAL'] ?? json['destinatario'] ?? '').toString(),
      ruc: (json['ruc'] ?? json['RUC'] ?? '').toString(),
      direccionesPartida: partidaList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_destinatario': idDestinatario,
      'razon_social': razonSocial,
      'ruc': ruc,
      'direcciones_partida':
          direccionesPartida.map((p) => (p as DireccionPartidaConfigModel).toJson()).toList(),
    };
  }
}

class DireccionPartidaConfigModel extends DireccionPartidaConfigEntity {
  const DireccionPartidaConfigModel({
    required super.idDireccionPartida,
    required super.direccion,
    required super.ubigeo,
    super.direccionesDestino,
  });

  factory DireccionPartidaConfigModel.fromJson(Map<String, dynamic> json) {
    var destinoList = <DireccionDestinoConfigModel>[];
    final rawDestino = json['direcciones_destino'] ??
        json['DIRECCIONES_DESTINO'] ??
        json['destinos'] ??
        json['llegadas'];
    if (rawDestino is List) {
      destinoList = rawDestino
          .map((d) => DireccionDestinoConfigModel.fromJson(d as Map<String, dynamic>))
          .toList();
    }

    return DireccionPartidaConfigModel(
      idDireccionPartida: (json['id_direccion_partida'] ??
              json['IDDIRECCION_PARTIDA'] ??
              json['id_partida'] ??
              json['id'] ??
              '')
          .toString(),
      direccion: (json['direccion'] ?? json['DIRECCION'] ?? '').toString(),
      ubigeo: (json['ubigeo'] ?? json['UBIGEO'] ?? '').toString(),
      direccionesDestino: destinoList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_direccion_partida': idDireccionPartida,
      'direccion': direccion,
      'ubigeo': ubigeo,
      'direcciones_destino':
          direccionesDestino.map((d) => (d as DireccionDestinoConfigModel).toJson()).toList(),
    };
  }
}

class DireccionDestinoConfigModel extends DireccionDestinoConfigEntity {
  const DireccionDestinoConfigModel({
    required super.idDireccionDestino,
    required super.direccion,
    required super.ubigeo,
  });

  factory DireccionDestinoConfigModel.fromJson(Map<String, dynamic> json) {
    return DireccionDestinoConfigModel(
      idDireccionDestino: (json['id_direccion_destino'] ??
              json['IDDIRECCION_DESTINO'] ??
              json['id_destino'] ??
              json['id'] ??
              '')
          .toString(),
      direccion: (json['direccion'] ?? json['DIRECCION'] ?? '').toString(),
      ubigeo: (json['ubigeo'] ?? json['UBIGEO'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_direccion_destino': idDireccionDestino,
      'direccion': direccion,
      'ubigeo': ubigeo,
    };
  }
}
