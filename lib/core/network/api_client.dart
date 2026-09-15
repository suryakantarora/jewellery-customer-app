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
  }) async {
    try {
      final response = await _dio.get<dynamic>(path, queryParameters: query);
      final body = response.data;
      if (body is Map<String, dynamic> && body.containsKey('success')) {
        return parse(body['data']);
      }
      return parse(body);
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
