import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/register/model/register_request_model.dart';
import 'entity/register_entity.dart';
import 'register_repo.dart';

class RegisterUsecase extends CoreUseCase<RegisterRequestModel, Either<Failure, RegisterEntity>> {
  final RegisterRepository repository;

  RegisterUsecase({required this.repository});

  @override
  Future<Either<Failure, RegisterEntity>> execute(RegisterRequestModel request) async {
    return await repository.register(request);
  }
}
