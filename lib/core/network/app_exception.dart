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

/// The customer token is missing, expired or revoked (401).
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Sign in again'])
    : super(statusCode: 401);
}

/// The request was understood and refused: a piece just sold (409), a rule
/// not met (422), a field rejected (400). [message] is the server's sentence,
/// written for customers, so screens may show it.
class RejectedException extends AppException {
  const RejectedException(super.message, int statusCode)
    : super(statusCode: statusCode);

  bool get isConflict => statusCode == 409;
}
