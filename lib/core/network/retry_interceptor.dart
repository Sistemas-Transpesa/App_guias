import 'dart:async';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final int initialDelayMs;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelayMs = 1000,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retryCount = extra['retry_count'] as int? ?? 0;

    // Retry only on network timeouts or 5xx server errors
    final shouldRetry = _isRetryable(err) && retryCount < maxRetries;

    if (shouldRetry) {
      final nextRetryCount = retryCount + 1;
      extra['retry_count'] = nextRetryCount;

      final delay = initialDelayMs * (1 << (nextRetryCount - 1)); // Exponential backoff: 1s, 2s, 4s
      await Future.delayed(Duration(milliseconds: delay));

      try {
        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            responseType: err.requestOptions.responseType,
            contentType: err.requestOptions.contentType,
            extra: extra,
          ),
        );
        return handler.resolve(response);
      } on DioException catch (retryErr) {
        return handler.next(retryErr);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  bool _isRetryable(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response != null && err.response!.statusCode != null && err.response!.statusCode! >= 500);
  }
}
