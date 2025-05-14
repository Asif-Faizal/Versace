import 'package:dartz/dartz.dart';
import 'package:versace/features/register/data/register/register_datasource.dart';
import 'package:versace/features/register/domain/register/register_repo.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/injection/injection_container.dart';
import '../../../../core/storage/storage_helper.dart';
import '../../domain/register/entity/register_entity.dart';
import 'model/register_request_model.dart';

class RegisterRepoImpl implements RegisterRepository {
  final RegisterDatasource datasource;
  RegisterRepoImpl({required this.datasource});

  @override
  Future<Either<Failure, RegisterEntity>> register(RegisterRequestModel request) async {
    final StorageHelper storageHelper = getIt<StorageHelper>();
    final response = await datasource.register(request);
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
