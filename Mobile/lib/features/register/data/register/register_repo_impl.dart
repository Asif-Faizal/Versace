import 'package:dartz/dartz.dart';
import 'package:versace/features/register/data/register/register_datasource.dart';
import 'package:versace/features/register/domain/register/register_repo.dart';

import '../../../../core/error/failures.dart';
import '../../domain/register/entity/register_entity.dart';
import 'model/register_request_model.dart';

class RegisterRepoImpl implements RegisterRepository {
  final RegisterDatasource datasource;
  RegisterRepoImpl({required this.datasource});

  @override
  Future<Either<Failure, RegisterEntity>> register(RegisterRequestModel request) async {
    return await datasource.register(request);
  }
}
