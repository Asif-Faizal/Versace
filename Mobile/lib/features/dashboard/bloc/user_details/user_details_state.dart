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
  const factory UserDetailsState.logoutLoading() = _LogoutLoading;
  const factory UserDetailsState.logoutSuccess() = _LogoutSuccess;
  const factory UserDetailsState.logoutFailure(String message) = _LogoutFailure;
  const factory UserDetailsState.error(String message) = _Error;
  const factory UserDetailsState.deleteAccountLoading() = _DeleteAccountLoading;
  const factory UserDetailsState.deleteAccountSuccess() = _DeleteAccountSuccess;
  const factory UserDetailsState.deleteAccountFailure(String message) = _DeleteAccountFailure;
}
