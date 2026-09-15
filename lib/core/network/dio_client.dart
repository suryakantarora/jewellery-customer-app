import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import 'app_exception.dart';

/// Assembles the configured [Dio] instance for the public storefront API.
///
/// The customer principal (C2/C10) will add an auth interceptor here; C1 only
/// stamps the tenant key and maps transport errors.
abstract final class DioClient {
  static const tenantHeader = 'X-Tenant-Key';

  static Dio create({required AppConfig config, required String tenantKey}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiRoot,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          tenantHeader: tenantKey,
        },
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    if (config.environment.allowsDeveloperTools) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) =>
            handler.reject(error.copyWith(error: mapDioError(error))),
      ),
    );

    return dio;
  }

  static AppException mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 404) return const NotFoundException();
        return ServerException('HTTP $status', status);
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return NetworkException(error.message ?? 'Network error');
    }
  }
}
