import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/register/entity/register_entity.dart';

part 'register_response_model.freezed.dart';
part 'register_response_model.g.dart';

@freezed
class RegisterResponseModel with _$RegisterResponseModel {
  const factory RegisterResponseModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required String accessToken,
    required String refreshToken,
  }) = _RegisterResponseModel;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) => _$RegisterResponseModelFromJson(json);

  factory RegisterResponseModel.fromEntity(RegisterEntity entity) => RegisterResponseModel(
    id: entity.id,
    email: entity.email,
    firstName: entity.firstName,
    lastName: entity.lastName,
    role: entity.role,
    accessToken: entity.accessToken,
    refreshToken: entity.refreshToken,
  );
}

extension RegisterResponseModelX on RegisterResponseModel {
  RegisterEntity toEntity() => RegisterEntity(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    role: role,
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
