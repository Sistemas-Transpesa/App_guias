import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/config_model.dart';
import '../models/guia_model.dart';
import '../models/guia_request_model.dart';
import '../models/sunat_mensaje_model.dart';

abstract class GuiasRemoteDataSource {
  Future<List<GuiaModel>> getGuias({required String idProgramacion});

  Future<ClienteConfigModel> getConfiguracion({
    required String idProgramacion,
    String? idCliente,
  });

  Future<GuiaModel> emitirGuia(GuiaRequestModel request);

  Future<SunatMensajeModel> getSunatMensaje({required String idGuia});

  Future<String> downloadPdf({
    required String idGuia,
    required String numeroGuia,
  });
}

class GuiasRemoteDataSourceImpl implements GuiasRemoteDataSource {
  final DioClient client;

  GuiasRemoteDataSourceImpl({required this.client});

  @override
  Future<List<GuiaModel>> getGuias({required String idProgramacion}) async {
    final response = await client.get(
      ApiEndpoints.getGuias,
      queryParameters: {'id_programacion': idProgramacion},
    );

    final data = response.data;
    if (data is List) {
      return data
          .map((item) => GuiaModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        return (data['data'] as List)
            .map((item) => GuiaModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data['guias'] is List) {
        return (data['guias'] as List)
            .map((item) => GuiaModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  @override
  Future<ClienteConfigModel> getConfiguracion({
    required String idProgramacion,
    String? idCliente,
  }) async {
    final response = await client.post(
      ApiEndpoints.configuracionRemitenteDestino,
      data: {
        'id_programacion': idProgramacion,
        if (idCliente != null && idCliente.isNotEmpty) 'id_cliente': idCliente,
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ClienteConfigModel.fromJson(data);
    }
    throw Exception('Estructura inválida de configuración devuelta por el servidor');
  }

  @override
  Future<GuiaModel> emitirGuia(GuiaRequestModel request) async {
    final response = await client.post(
      ApiEndpoints.emitirGuiaTransportista,
      data: request.toJson(),
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return GuiaModel.fromJson(data);
    }
    throw Exception('Respuesta inválida al emitir la guía de transportista');
  }

  @override
  Future<SunatMensajeModel> getSunatMensaje({required String idGuia}) async {
    final response = await client.get(
      ApiEndpoints.guiaTransportistaMensaje,
      queryParameters: {'id_guia': idGuia},
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return SunatMensajeModel.fromJson(data);
    }
    throw Exception('Error al obtener mensaje de estado SUNAT');
  }

  @override
  Future<String> downloadPdf({
    required String idGuia,
    required String numeroGuia,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final sanitizedNum = numeroGuia.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    final filePath = '${tempDir.path}/guia_$sanitizedNum.pdf';

    // Verify if already cached locally
    final file = File(filePath);
    if (await file.exists() && (await file.length()) > 0) {
      return filePath;
    }

    await client.download(
      '${ApiEndpoints.downloadPdfGuia}/$idGuia',
      filePath,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
      ),
    );

    return filePath;
  }
}
