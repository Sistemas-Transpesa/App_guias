import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/viaje_model.dart';

abstract class ViajesRemoteDataSource {
  Future<List<ViajeModel>> getViajes({
    String? fechaInicio,
    String? fechaFin,
  });
}

class ViajesRemoteDataSourceImpl implements ViajesRemoteDataSource {
  final DioClient client;

  ViajesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ViajeModel>> getViajes({
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final queryParams = <String, dynamic>{};
    if (fechaInicio != null && fechaInicio.isNotEmpty) {
      queryParams['fecha_inicio'] = fechaInicio;
    }
    if (fechaFin != null && fechaFin.isNotEmpty) {
      queryParams['fecha_fin'] = fechaFin;
    }

    final response = await client.get(
      ApiEndpoints.getViajes,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = response.data;
    if (data is List) {
      return data
          .map((item) => ViajeModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic>) {
      // If wrapped in response payload like { "data": [...] }
      if (data['data'] is List) {
        return (data['data'] as List)
            .map((item) => ViajeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data['viajes'] is List) {
        return (data['viajes'] as List)
            .map((item) => ViajeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }

    return [];
  }
}
