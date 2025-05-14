import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/get_user_details/entity/get_user_details_entity.dart';

part 'get_user_details_model.freezed.dart';
part 'get_user_details_model.g.dart';

@freezed
class GetUserDetailsModel with _$GetUserDetailsModel {
  const factory GetUserDetailsModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    @Default(false) bool isActive,
    @Default(false) bool isEmailVerified,
  }) = _GetUserDetailsModel;

  factory GetUserDetailsModel.fromJson(Map<String, dynamic> json) => _$GetUserDetailsModelFromJson(json);

  static GetUserDetailsModel fromApiJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return GetUserDetailsModel(
      id: user['_id'] as String,
      email: user['email'] as String,
      firstName: user['firstName'] as String,
      lastName: user['lastName'] as String,
      role: user['role'] as String,
      isActive: user['isActive'] as bool,
      isEmailVerified: user['isEmailVerified'] as bool,
    );
  }

  factory GetUserDetailsModel.fromEntity(GetUserDetailsEntity entity) => GetUserDetailsModel(
    id: entity.id,
    email: entity.email,
    firstName: entity.firstName,
    lastName: entity.lastName,
    role: entity.role,
    isActive: entity.isActive,
    isEmailVerified: entity.isEmailVerified,
  );
}

extension GetUserDetailsModelX on GetUserDetailsModel {
  GetUserDetailsEntity toEntity() => GetUserDetailsEntity(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    role: role,
    isActive: isActive,
    isEmailVerified: isEmailVerified,
  );
}
