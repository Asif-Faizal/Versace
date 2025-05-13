import 'package:dartz/dartz.dart';
import 'package:versace/core/error/failures.dart';
import 'package:versace/features/register/domain/email_verification/entity/email_verification_entity.dart';

abstract class EmailVerificationRepository {
  Future<Either<Failure, EmailVerificationEntity>> sendOtp(String email);
  Future<Either<Failure, EmailVerificationEntity>> verifyOtp(String email, String otp);
}