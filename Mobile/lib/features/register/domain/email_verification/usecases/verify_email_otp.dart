import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../email_verification_repo.dart';
import '../entity/email_verification_entity.dart';

class VerifyEmailOtpUsecase extends CoreUseCase<Map<String, String>, Either<Failure, EmailVerificationEntity>> {
  final EmailVerificationRepository repository;

  VerifyEmailOtpUsecase({required this.repository});

  @override
  Future<Either<Failure, EmailVerificationEntity>> execute(Map<String, String> params) async {
    final email = params['email']!;
    final otp = params['otp']!;
    return await repository.verifyOtp(email, otp);
  }
}
