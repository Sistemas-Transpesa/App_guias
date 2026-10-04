class AppConstants {
  AppConstants._();

  // Storage Keys
  static const String keyToken = 'jwt_auth_token';
  static const String keyReference = 'user_reference_id';
  static const String keyUserJson = 'user_profile_json';
  static const String keyRememberUser = 'remember_username';

  // SUNAT Statuses
  static const String sunatAceptado = 'ACEPTADO';
  static const String sunatRechazado = 'RECHAZADO';
  static const String sunatPendiente = 'PENDIENTE';
  static const String sunatAnulado = 'ANULADO';

  // Trip Types
  static const String tipoViajeTicket = '1';

  // Polling Intervals
  static const Duration pollingInterval = Duration(minutes: 2);
  static const int maxRetryAttempts = 3;
}
