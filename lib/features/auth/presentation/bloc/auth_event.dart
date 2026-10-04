import 'package:equatable/equatable.dart';
import '../../domain/entities/usuario_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatusRequested extends AuthEvent {}

class AuthUserLoggedIn extends AuthEvent {
  final UsuarioEntity user;

  const AuthUserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {}
