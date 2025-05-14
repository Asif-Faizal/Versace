import 'package:dartz/dartz.dart';
import 'package:versace/core/error/failures.dart';
import 'package:versace/features/login/data/login/models/login_request_model.dart';
import 'package:versace/features/login/domain/login/entities/login_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginEntity>> login(LoginRequestModel request);
}
