import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_details_entity.freezed.dart';

@freezed
class UpdateUserDetailsEntity with _$UpdateUserDetailsEntity {
  const factory UpdateUserDetailsEntity({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required String accessToken,
    required String refreshToken,
  }) = _UpdateUserDetailsEntity;
}
