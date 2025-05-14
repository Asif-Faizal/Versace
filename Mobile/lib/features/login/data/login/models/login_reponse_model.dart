import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/login/entities/login_entity.dart';

part 'login_reponse_model.freezed.dart';
part 'login_reponse_model.g.dart';

@freezed
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required String accessToken,
    required String refreshToken,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);

  factory LoginResponseModel.fromEntity(LoginEntity entity) => LoginResponseModel(
    id: entity.id,
    email: entity.email,
    firstName: entity.firstName,
    lastName: entity.lastName,
    role: entity.role,
    accessToken: entity.accessToken,
    refreshToken: entity.refreshToken,
  );
}

extension LoginResponseModelX on LoginResponseModel {
  LoginEntity toEntity() => LoginEntity(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    role: role,
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
