import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/user_details/entity/update_user_details_entity.dart';
import '../../domain/user_details/entity/user_details_entity.dart';

part 'user_details_state.freezed.dart';

@freezed
class UserDetailsState with _$UserDetailsState {
  const factory UserDetailsState.initial() = _Initial;
  const factory UserDetailsState.loading() = _Loading;
  const factory UserDetailsState.success(UserDetailsEntity userDetailsEntity) = _Success;
  const factory UserDetailsState.updateSuccess(UpdateUserDetailsEntity updateUserDetailsEntity) = _UpdateSuccess;
  const factory UserDetailsState.error(String message) = _Error;
}
