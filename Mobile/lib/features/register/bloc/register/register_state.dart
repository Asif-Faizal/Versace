import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/register/entity/register_entity.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = _Initial;
  const factory RegisterState.loading() = _Loading;
  const factory RegisterState.success(RegisterEntity registerEntity) = _Success;
  const factory RegisterState.error(String message) = _Error;
}