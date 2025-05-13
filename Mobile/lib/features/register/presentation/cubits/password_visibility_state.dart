import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_visibility_state.freezed.dart';

@freezed
class PasswordVisibilityState with _$PasswordVisibilityState {
  const factory PasswordVisibilityState({
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isConfirmPasswordVisible,
  }) = _PasswordVisibilityState;
}