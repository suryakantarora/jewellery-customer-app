import 'package:dio/dio.dart';

import 'app_exception.dart';
import 'dio_client.dart';

/// Typed wrapper over [Dio] that unwraps the backend's `ApiResponse` envelope
/// (`{success, data, ...}`) so callers receive the payload directly and every
/// failure arrives as an [AppException].
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Dio get raw => _dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(Object? data) parse,
  }) => send('GET', path, query: query, parse: parse);

  Future<T> post<T>(
    String path, {
    Object? body,
    required T Function(Object? data) parse,
  }) => send('POST', path, body: body, parse: parse);

  Future<T> put<T>(
    String path, {
    Object? body,
    required T Function(Object? data) parse,
  }) => send('PUT', path, body: body, parse: parse);

  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(Object? data) parse,
  }) => send('DELETE', path, query: query, parse: parse);

  Future<T> send<T>(
    String method,
    String path, {
    Map<String, dynamic>? query,
    Object? body,
    required T Function(Object? data) parse,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: query,
        options: Options(method: method),
      );
      final payload = response.data;
      if (payload is Map<String, dynamic> && payload.containsKey('success')) {
        return parse(payload['data']);
      }
      return parse(payload);
    } on DioException catch (error) {
      final mapped = error.error;
      throw mapped is AppException ? mapped : DioClient.mapDioError(error);
    } on AppException {
      rethrow;
    } on Object catch (error) {
      throw ParseException(error.toString());
    }
  }
}
