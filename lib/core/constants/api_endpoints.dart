import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api-guias.transpesa.com.pe/api';

  static int get timeoutSeconds =>
      int.tryParse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '30') ?? 30;

  // Auth Endpoints
  static const String authenticateMovil = '/authenticate-movil';

  // Viajes Endpoints
  static const String getViajes = '/get-viajes';

  // Guías Transportista Endpoints
  static const String getGuias = '/get-guias';
  static const String configuracionRemitenteDestino =
      '/configuracion-remitente-destino';
  static const String emitirGuiaTransportista = '/guia-transportista';
  static const String guiaTransportistaMensaje = '/guia-transportista/mensaje';
  static const String downloadPdfGuia = '/guia-transportista/pdf';
}
