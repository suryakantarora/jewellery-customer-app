/// Every failure the app can surface, as a closed set.
///
/// Customers never see technical text: screens map these to localised copy in
/// `ErrorState`, and the [message] is for logs only.
sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType($message)';
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No connection']);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found'])
    : super(statusCode: 404);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error', int? statusCode])
    : super(statusCode: statusCode);
}

class ParseException extends AppException {
  const ParseException([super.message = 'Unexpected response']);
}
