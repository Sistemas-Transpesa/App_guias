import '../../domain/entities/usuario_entity.dart';

class UsuarioModel extends UsuarioEntity {
  const UsuarioModel({
    required super.id,
    required super.username,
    required super.nombre,
    super.dni,
    super.token,
    super.reference,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    // Handle various response wrappers from backend
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;

    return UsuarioModel(
      id: (data['id'] ?? data['ID'] ?? data['id_usuario'] ?? '').toString(),
      username: (data['username'] ?? data['usuario'] ?? data['USUARIO'] ?? '').toString(),
      nombre: (data['nombre'] ?? data['NOMBRE'] ?? data['name'] ?? data['username'] ?? '').toString(),
      dni: data['dni']?.toString() ?? data['DNI']?.toString(),
      token: (json['token'] ?? json['access_token'] ?? data['token'])?.toString(),
      reference: (json['reference'] ?? data['reference'] ?? data['id_chofer'] ?? data['IDCHOFER'] ?? data['id'] ?? '')?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nombre': nombre,
      'dni': dni,
      'token': token,
      'reference': reference,
    };
  }

  UsuarioEntity toEntity() => this;
}
