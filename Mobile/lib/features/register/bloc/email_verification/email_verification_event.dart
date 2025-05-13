import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_verification_event.freezed.dart';

@freezed
class EmailVerificationEvent with _$EmailVerificationEvent {
  const factory EmailVerificationEvent.sendOtpRequested({
    required String email,
  }) = SendOtpRequested;

  const factory EmailVerificationEvent.verifyOtpRequested({
    required String email,
    required String otp,
  }) = VerifyOtpRequested;
}