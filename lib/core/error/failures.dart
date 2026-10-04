import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Sesión no autorizada o expirada'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sin conexión a Internet. Verifique su red.'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Error al acceder a los datos locales'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
