import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/get_user_details/entity/get_user_details_entity.dart';
import '../../domain/get_user_details/get_user_details_repo.dart';
import 'get_user_details_datasource.dart';

class GetUserDetailsRepoImpl implements GetUserDetailsRepo {
  final GetUserDetailsDatasource datasource;
  GetUserDetailsRepoImpl({required this.datasource});
  @override
  Future<Either<Failure, GetUserDetailsEntity>> getUserDetails() async {
    final response = await datasource.getUserDetails();
    return response.fold(
      (failure) => Left(failure),
      (entity) => Right(entity),
    );
  }
}
