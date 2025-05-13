import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_verification_state.freezed.dart';

@freezed
class EmailVerificationState with _$EmailVerificationState {
  const factory EmailVerificationState.initial() = _Initial;
  const factory EmailVerificationState.loading() = _Loading;
  const factory EmailVerificationState.otpSent(String message) = _OtpSent;
  const factory EmailVerificationState.verified(String message) = _Verified;
  const factory EmailVerificationState.error(String message) = _Error;
}