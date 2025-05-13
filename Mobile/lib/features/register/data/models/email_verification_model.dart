import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/email_verification/email_verification_entity.dart';

part 'email_verification_model.freezed.dart';
part 'email_verification_model.g.dart';

@freezed
class EmailVerificationModel with _$EmailVerificationModel {
  const factory EmailVerificationModel({
    required String message,
  }) = _EmailVerificationModel;

  factory EmailVerificationModel.fromJson(Map<String, dynamic> json) => _$EmailVerificationModelFromJson(json);
}

extension EmailVerificationModelX on EmailVerificationModel {
  EmailVerificationEntity toEntity() => EmailVerificationEntity(message: message);
}