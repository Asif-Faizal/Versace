import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../data/user_details/model/update_user_request_model.dart';
import '../entity/update_user_details_entity.dart';
import '../user_details_repo.dart';

class UpdateUserDetailsUsecase extends CoreUseCase<UpdateUserRequestModel, Either<Failure, UpdateUserDetailsEntity>> {
  final UserDetailsRepo repository;

  UpdateUserDetailsUsecase({required this.repository});

  @override
  Future<Either<Failure, UpdateUserDetailsEntity>> execute(UpdateUserRequestModel params) async {
    return await repository.updateUserDetails(params);
  }
}
