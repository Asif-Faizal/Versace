import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_visibility_login_state.freezed.dart';

@freezed
class PasswordVisibilityLoginState with _$PasswordVisibilityLoginState {
  const factory PasswordVisibilityLoginState({
    @Default(false) bool isPasswordVisible,
  }) = _PasswordVisibilityLoginState;
}