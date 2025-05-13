abstract class Exception extends Error {
  final String message;
  final int statusCode;

  Exception({required this.message, required this.statusCode});
}

class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({
    required this.message,
    this.statusCode = 500,
  });

  @override
  String toString() => 'ServerException: $message (Status Code: $statusCode)';
  
  @override
  StackTrace? get stackTrace => StackTrace.current;
} 