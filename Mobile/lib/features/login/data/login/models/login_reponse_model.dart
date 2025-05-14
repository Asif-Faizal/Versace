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

  static LoginResponseModel fromApiJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return LoginResponseModel(
      id: user['_id'] as String,
      email: user['email'] as String,
      firstName: user['firstName'] as String,
      lastName: user['lastName'] as String,
      role: user['role'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

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
