import 'package:dartz/dartz.dart';
import 'package:versace/core/error/failures.dart';
import 'package:versace/features/dashboard/domain/get_user_details/entity/get_user_details_entity.dart';

abstract class GetUserDetailsRepo {
  Future<Either<Failure, GetUserDetailsEntity>> getUserDetails();
}
