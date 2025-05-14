import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/user_details/model/update_user_request_model.dart';

part 'user_details_event.freezed.dart';

@freezed
class UserDetailsEvent with _$UserDetailsEvent {
  const factory UserDetailsEvent.userDetailsRequested() = UserDetailsRequested;
  const factory UserDetailsEvent.updateUserDetailsRequested(UpdateUserRequestModel updateUserRequestModel) = UpdateUserDetailsRequested;
  const factory UserDetailsEvent.logoutRequested() = LogoutRequested;
  const factory UserDetailsEvent.deleteAccountRequested(String password) = DeleteAccountRequested;
}