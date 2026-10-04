import 'package:equatable/equatable.dart';

class UsuarioEntity extends Equatable {
  final String id;
  final String username;
  final String nombre;
  final String? dni;
  final String? token;
  final String? reference; // Driver ID / Reference

  const UsuarioEntity({
    required this.id,
    required this.username,
    required this.nombre,
    this.dni,
    this.token,
    this.reference,
  });

  @override
  List<Object?> get props => [id, username, nombre, dni, token, reference];
}
