import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/user_details/entity/update_user_details_entity.dart';

part 'update_user_reponse_model.freezed.dart';
part 'update_user_reponse_model.g.dart';

@freezed
class UpdateUserDetailsModel with _$UpdateUserDetailsModel {
  const factory UpdateUserDetailsModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required String accessToken,
    required String refreshToken,
  }) = _UpdateUserDetailsModel;

  factory UpdateUserDetailsModel.fromJson(Map<String, dynamic> json) => _$UpdateUserDetailsModelFromJson(json);

  static UpdateUserDetailsModel fromApiJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return UpdateUserDetailsModel(
      id: user['_id'] as String,
      email: user['email'] as String,
      firstName: user['firstName'] as String,
      lastName: user['lastName'] as String,
      role: user['role'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  factory UpdateUserDetailsModel.fromEntity(UpdateUserDetailsEntity entity) => UpdateUserDetailsModel(
    id: entity.id,
    email: entity.email,
    firstName: entity.firstName,
    lastName: entity.lastName,
    role: entity.role,
    accessToken: entity.accessToken,
    refreshToken: entity.refreshToken,
  );
}

extension UpdateUserDetailsModelX on UpdateUserDetailsModel {
  UpdateUserDetailsEntity toEntity() => UpdateUserDetailsEntity(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    role: role,
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
