import 'package:dartz/dartz.dart';
import 'package:versace/core/error/failures.dart';
import 'package:versace/features/login/data/login/login_datasource.dart';
import 'package:versace/features/login/domain/login/entities/login_entity.dart';
import 'package:versace/features/login/domain/login/login_repo.dart';

import '../../../../core/injection/injection_container.dart';
import '../../../../core/storage/storage_helper.dart';
import 'models/login_request_model.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LoginEntity>> login(LoginRequestModel request) async {
    final StorageHelper storageHelper = getIt<StorageHelper>();
    final response = await remoteDataSource.login(request);
    final accessToken = response.fold(
      (failure) => null,
      (entity) => entity.accessToken,
    );
    final refreshToken = response.fold(
      (failure) => null,
      (entity) => entity.refreshToken,
    );
    if (accessToken != null && refreshToken != null) {
      await storageHelper.setAuthData(
        isLoggedIn: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
    return response.fold((failure) => Left(failure), (entity) => Right(entity));
  }
}
