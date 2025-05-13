import 'package:equatable/equatable.dart';

/// Base class for all route arguments
abstract class RouteArguments extends Equatable {
  const RouteArguments();
  
  @override
  bool get stringify => true;
}

class EnterPasswordArguments extends RouteArguments {
  final String email;
  final String firstName;
  final String lastName;

  const EnterPasswordArguments({required this.email, required this.firstName, required this.lastName});

  @override
  List<Object?> get props => [email, firstName, lastName];
}
