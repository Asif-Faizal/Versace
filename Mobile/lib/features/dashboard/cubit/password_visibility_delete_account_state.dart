import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_visibility_delete_account_state.freezed.dart';

@freezed
class PasswordVisibilityDeleteAccountState with _$PasswordVisibilityDeleteAccountState {
  const factory PasswordVisibilityDeleteAccountState({
    @Default(false) bool isPasswordVisible,
  }) = _PasswordVisibilityDeleteAccountState;
} 