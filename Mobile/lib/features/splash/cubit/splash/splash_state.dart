import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({
    @Default(SplashStateType.initial) SplashStateType type,
  }) = _SplashState;
}

enum SplashStateType { initial, typing, showingImage, completed }
