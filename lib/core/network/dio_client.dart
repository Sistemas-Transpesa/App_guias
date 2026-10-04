import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_endpoints.dart';
import '../error/exceptions.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';
import 'retry_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient({
    required SecureStorageService secureStorage,
    void Function()? onUnauthorized,
    bool enableLogging = true,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: Duration(seconds: ApiEndpoints.timeoutSeconds),
        receiveTimeout: Duration(seconds: ApiEndpoints.timeoutSeconds),
        sendTimeout: Duration(seconds: ApiEndpoints.timeoutSeconds),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        secureStorage,
        onUnauthorized: onUnauthorized,
      ),
    );

    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        maxRetries: 3,
      ),
    );

    if (enableLogging) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  // Generic Request Helper with clean exception mapping
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> download(
    String urlPath,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      return await dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkException(
        message: 'No se pudo conectar con el servidor. Compruebe su conexión.',
      );
    }

    if (error.response?.statusCode == 401) {
      return const UnauthorizedException();
    }

    final message = _extractErrorMessage(error.response?.data) ??
        error.message ??
        'Ocurrió un error inesperado en el servidor';

    return ServerException(
      message: message,
      statusCode: error.response?.statusCode,
    );
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('mensaje') && data['mensaje'] != null) {
        return data['mensaje'].toString();
      }
      if (data.containsKey('message') && data['message'] != null) {
        return data['message'].toString();
      }
      if (data.containsKey('error') && data['error'] != null) {
        return data['error'].toString();
      }
    }
    return null;
  }
}
