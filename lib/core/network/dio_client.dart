import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import 'app_exception.dart';

/// Assembles the configured [Dio] instance for the public storefront API.
///
/// Stamps the tenant key, attaches the customer token when there is one, and
/// maps transport errors. A 401 on a request that carried a token means the
/// token is dead; [onSessionExpired] lets the app fall back to guest.
abstract final class DioClient {
  static const tenantHeader = 'X-Tenant-Key';

  static Dio create({
    required AppConfig config,
    required String tenantKey,
    String? Function()? readToken,
    void Function()? onSessionExpired,
  }) {
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
        onRequest: (options, handler) {
          final token = readToken?.call();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final sentToken = error.requestOptions.headers.containsKey('Authorization');
          if (error.response?.statusCode == 401 && sentToken) {
            onSessionExpired?.call();
          }
          handler.reject(error.copyWith(error: mapDioError(error)));
        },
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
        if (status == 401) return UnauthorizedException(_serverMessage(error) ?? 'Sign in again');
        if (status == 400 || status == 403 || status == 409 || status == 422) {
          return RejectedException(_serverMessage(error) ?? 'HTTP $status', status!);
        }
        return ServerException('HTTP $status', status);
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return NetworkException(error.message ?? 'Network error');
    }
  }

  /// The `message` of the backend's `ApiError` body, when there is one.
  static String? _serverMessage(DioException error) {
    final body = error.response?.data;
    final message = body is Map ? body['message'] : null;
    return message is String && message.isNotEmpty ? message : null;
  }
}
