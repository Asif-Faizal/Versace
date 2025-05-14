import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../user_details_repo.dart';

class DeleteAccountUsecase extends CoreUseCase<String, Either<Failure, void>> {
  final UserDetailsRepo repository;

  DeleteAccountUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> execute(String params) async {
    return await repository.deleteAccount(params);
  }
}
