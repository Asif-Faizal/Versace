import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_verification_entity.freezed.dart';

@freezed
class EmailVerificationEntity with _$EmailVerificationEntity {
  const factory EmailVerificationEntity({
    required String message,
  }) = _EmailVerificationEntity;
}