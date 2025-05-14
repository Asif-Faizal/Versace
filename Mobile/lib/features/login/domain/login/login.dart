import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/login/models/login_request_model.dart';
import 'entities/login_entity.dart';
import 'login_repo.dart';

class LoginUsecase extends CoreUseCase<LoginRequestModel, Either<Failure, LoginEntity>> {
  final LoginRepository repository;

  LoginUsecase({required this.repository});

  @override
  Future<Either<Failure, LoginEntity>> execute(LoginRequestModel request) async {
    return await repository.login(request);
  }
}
