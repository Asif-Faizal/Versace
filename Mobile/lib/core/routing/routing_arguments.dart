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

class VerifyOtpArguments extends RouteArguments {
  final String email;

  const VerifyOtpArguments({required this.email});

  @override
  List<Object?> get props => [email];
}

class EditProfileArguments extends RouteArguments {
  final String firstName;
  final String lastName;

  const EditProfileArguments({required this.firstName, required this.lastName});

  @override
  List<Object?> get props => [firstName, lastName];
}

class DeleteAccountArguments extends RouteArguments {
  final String email;

  const DeleteAccountArguments({required this.email});

  @override
  List<Object?> get props => [email];
}
