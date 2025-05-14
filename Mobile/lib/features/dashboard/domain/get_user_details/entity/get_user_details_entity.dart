import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_details_entity.freezed.dart';

@freezed
class GetUserDetailsEntity with _$GetUserDetailsEntity {
  const factory GetUserDetailsEntity({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    @Default(false) bool isActive,
    @Default(false) bool isEmailVerified,
  }) = _GetUserDetailsEntity;
}
