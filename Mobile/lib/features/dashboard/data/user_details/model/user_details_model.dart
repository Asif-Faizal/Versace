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
    return UserDetailsModel(
      id: json['_id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      isEmailVerified: json['isEmailVerified'] as bool,
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
