import 'package:dartz/dartz.dart';
import 'package:versace/core/error/failures.dart';
import 'package:versace/features/dashboard/domain/user_details/entity/user_details_entity.dart';

import '../../data/user_details/model/update_user_request_model.dart';
import 'entity/update_user_details_entity.dart';

abstract class UserDetailsRepo {
  Future<Either<Failure, UserDetailsEntity>> getUserDetails();
  Future<Either<Failure, UpdateUserDetailsEntity>> updateUserDetails(UpdateUserRequestModel updateUserRequestModel);
  Future<Either<Failure, void>> logout();
}
