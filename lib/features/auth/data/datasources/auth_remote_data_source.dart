import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/usuario_model.dart';

abstract class AuthRemoteDataSource {
  Future<UsuarioModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UsuarioModel> login({
    required String username,
    required String password,
  }) async {
    final response = await client.post(
      ApiEndpoints.authenticateMovil,
      data: {
        'username': username.trim(),
        'password': password,
      },
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return UsuarioModel.fromJson(responseData);
    } else {
      throw Exception('Formato de respuesta inválido del servidor de autenticación');
    }
  }
}
