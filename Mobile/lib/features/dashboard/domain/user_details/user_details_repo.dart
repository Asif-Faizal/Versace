import 'package:dartz/dartz.dart';
import 'package:versace/core/error/failures.dart';
import 'package:versace/features/dashboard/domain/user_details/entity/user_details_entity.dart';

abstract class UserDetailsRepo {
  Future<Either<Failure, UserDetailsEntity>> getUserDetails();
}
