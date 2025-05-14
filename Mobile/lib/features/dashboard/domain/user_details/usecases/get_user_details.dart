import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entity/user_details_entity.dart';
import '../user_details_repo.dart';

class GetUserDetailsUsecase extends CoreUseCase<void, Either<Failure, UserDetailsEntity>> {
  final UserDetailsRepo repository;

  GetUserDetailsUsecase({required this.repository});

  @override
  Future<Either<Failure, UserDetailsEntity>> execute(void params) async {
    return await repository.getUserDetails();
  }
}
