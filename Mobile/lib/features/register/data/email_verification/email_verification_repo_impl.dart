import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/email_verification/email_verification_repo.dart';
import '../../domain/email_verification/entity/email_verification_entity.dart';
import 'email_verification_datasource.dart';

class EmailVerificationRepositoryImpl extends EmailVerificationRepository {
  final EmailVerificationDataSource dataSource;

  EmailVerificationRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, EmailVerificationEntity>> sendOtp(String email) async {
    return await dataSource.sendOtp(email);
  }

  @override
  Future<Either<Failure, EmailVerificationEntity>> verifyOtp(String email, String otp) async {
    return await dataSource.verifyOtp(email, otp);
  }
}
