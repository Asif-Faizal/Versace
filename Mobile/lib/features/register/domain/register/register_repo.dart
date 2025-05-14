
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/register/model/register_request_model.dart';
import '../../domain/register/entity/register_entity.dart';

abstract class RegisterRepository {
  Future<Either<Failure, RegisterEntity>> register(RegisterRequestModel request);
}