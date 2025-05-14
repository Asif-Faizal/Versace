import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/login/entities/login_entity.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success(LoginEntity loginEntity) = _Success;
  const factory LoginState.error(String message) = _Error;
}
