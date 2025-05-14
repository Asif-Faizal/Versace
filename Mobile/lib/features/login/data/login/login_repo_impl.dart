import 'package:dartz/dartz.dart';
import 'package:versace/core/error/failures.dart';
import 'package:versace/features/login/data/login/login_datasource.dart';
import 'package:versace/features/login/domain/login/entities/login_entity.dart';
import 'package:versace/features/login/domain/login/login_repo.dart';

import 'models/login_request_model.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LoginEntity>> login(LoginRequestModel request) async {
    return await remoteDataSource.login(request);
  }
}
