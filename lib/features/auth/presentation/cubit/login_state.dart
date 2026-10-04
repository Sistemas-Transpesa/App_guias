import 'package:equatable/equatable.dart';
import '../../domain/entities/usuario_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  final String? initialUsername;

  const LoginInitial({this.initialUsername});

  @override
  List<Object?> get props => [initialUsername];
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UsuarioEntity user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
