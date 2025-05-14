import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details_entity.freezed.dart';

@freezed
class UserDetailsEntity with _$UserDetailsEntity {
  const factory UserDetailsEntity({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    @Default(false) bool isActive,
    @Default(false) bool isEmailVerified,
  }) = _UserDetailsEntity;
}
