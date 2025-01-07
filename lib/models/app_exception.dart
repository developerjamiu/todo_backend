/// AppException class
class AppException implements Exception {
  /// AppException constructor
  AppException(this.message);

  /// Error message
  final String message;

  @override
  String toString() => message;
}
