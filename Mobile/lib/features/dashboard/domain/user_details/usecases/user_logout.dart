import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../user_details_repo.dart';

class UserLogoutUsecase extends CoreUseCase<void, Either<Failure, void>> {
  final UserDetailsRepo repository;

  UserLogoutUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> execute(void params) async {
    return await repository.logout();
  }
}
