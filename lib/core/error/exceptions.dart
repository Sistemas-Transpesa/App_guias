class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException({this.message = 'Sesión expirada o credenciales inválidas'});

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Sin conexión a Internet. Verifique su red.'});

  @override
  String toString() => 'NetworkException(message: $message)';
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Error al acceder al almacenamiento local'});

  @override
  String toString() => 'CacheException(message: $message)';
}
