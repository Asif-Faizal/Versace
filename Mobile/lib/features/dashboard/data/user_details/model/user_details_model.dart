import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/user_details/entity/user_details_entity.dart';

part 'user_details_model.freezed.dart';
part 'user_details_model.g.dart';

@freezed
class UserDetailsModel with _$UserDetailsModel {
  const factory UserDetailsModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    @Default(false) bool isActive,
    @Default(false) bool isEmailVerified,
  }) = _GetUserDetailsModel;

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => _$UserDetailsModelFromJson(json);

  static UserDetailsModel fromApiJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return UserDetailsModel(
      id: user['_id'] as String,
      email: user['email'] as String,
      firstName: user['firstName'] as String,
      lastName: user['lastName'] as String,
      role: user['role'] as String,
      isActive: user['isActive'] as bool,
      isEmailVerified: user['isEmailVerified'] as bool,
    );
  }

  factory UserDetailsModel.fromEntity(UserDetailsEntity entity) => UserDetailsModel(
    id: entity.id,
    email: entity.email,
    firstName: entity.firstName,
    lastName: entity.lastName,
    role: entity.role,
    isActive: entity.isActive,
    isEmailVerified: entity.isEmailVerified,
  );
}

extension UserDetailsModelX on UserDetailsModel {
  UserDetailsEntity toEntity() => UserDetailsEntity(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    role: role,
    isActive: isActive,
    isEmailVerified: isEmailVerified,
  );
}
