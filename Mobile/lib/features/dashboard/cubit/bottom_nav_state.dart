import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_nav_state.freezed.dart';

@freezed
class BottomNavState with _$BottomNavState {
  const factory BottomNavState.home() = HomeNav;
  const factory BottomNavState.favorites() = FavoritesNav;
  const factory BottomNavState.cart() = CartNav;
  const factory BottomNavState.profile() = ProfileNav;
  const factory BottomNavState.search() = SearchNav;
  const factory BottomNavState.editProfile() = EditProfileNav;
} 