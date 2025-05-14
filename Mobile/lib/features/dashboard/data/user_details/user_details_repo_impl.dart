import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/user_details/entity/update_user_details_entity.dart';
import '../../domain/user_details/entity/user_details_entity.dart';
import '../../domain/user_details/user_details_repo.dart';
import 'model/update_user_request_model.dart';
import 'user_details_datasource.dart';

class UserDetailsRepoImpl implements UserDetailsRepo {
  final UserDetailsDatasource datasource;
  UserDetailsRepoImpl({required this.datasource});
  @override
  Future<Either<Failure, UserDetailsEntity>> getUserDetails() async {
    final response = await datasource.getUserDetails();
    return response.fold(
      (failure) => Left(failure),
      (entity) => Right(entity),
    );
  }

  @override
  Future<Either<Failure, UpdateUserDetailsEntity>> updateUserDetails(UpdateUserRequestModel updateUserRequestModel) async {
    final response = await datasource.updateUserDetails(updateUserRequestModel);
    return response.fold(
      (failure) => Left(failure),
      (entity) => Right(entity),
    );
  }
}
