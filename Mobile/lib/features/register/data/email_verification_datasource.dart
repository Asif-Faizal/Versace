import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../core/error/failures.dart';
import '../domain/email_verification/entity/email_verification_entity.dart';

abstract class EmailVerificationDataSource {
  Future<Either<Failure, EmailVerificationEntity>> sendOtp(String email);
  Future<Either<Failure, EmailVerificationEntity>> verifyOtp(String email, String otp);
}

class EmailVerificationDataSourceImpl extends EmailVerificationDataSource {
  final http.Client client;

  EmailVerificationDataSourceImpl({required this.client});

  @override
  Future<Either<Failure, EmailVerificationEntity>> sendOtp(String email) async {
    return right(EmailVerificationEntity(message: 'Email sent successfully'));
  }

  @override
  Future<Either<Failure, EmailVerificationEntity>> verifyOtp(String email, String otp) async {
    return right(EmailVerificationEntity(message: 'Email verified successfully'));
  }
}