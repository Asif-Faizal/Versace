import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../email_verification_repo.dart';
import '../entity/email_verification_entity.dart';

class SentEmailOtpUsecase extends CoreUseCase<String, Either<Failure, EmailVerificationEntity>> {
  final EmailVerificationRepository repository;

  SentEmailOtpUsecase({required this.repository});

  @override
  Future<Either<Failure, EmailVerificationEntity>> execute(String email) async {
    return await repository.sendOtp(email);
  }
}
