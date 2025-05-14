import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details_event.freezed.dart';

@freezed
class UserDetailsEvent with _$UserDetailsEvent {
  const factory UserDetailsEvent.userDetailsRequested() = UserDetailsRequested;
}