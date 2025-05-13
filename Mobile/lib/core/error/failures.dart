import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String message;

  ServerFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class InvalidInputFailure extends Failure {}

class AuthenticationFailure extends Failure {}

class PermissionFailure extends Failure {}

class LocationFailure extends Failure {}

class DatabaseFailure extends Failure {}

class ValidationFailure extends Failure {
  final String message;
  
  ValidationFailure({required this.message});
  
  @override
  List<Object> get props => [message];
}

class UnknownFailure extends Failure {
  final String message;
  
  UnknownFailure({required this.message});
  
  @override
  List<Object> get props => [message];
}
