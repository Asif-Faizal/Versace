import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_scroll_state.freezed.dart';

@freezed
class AutoScrollState with _$AutoScrollState {
  const factory AutoScrollState({
    @Default(true) bool isScrolling,
    @Default(0.0) double scrollPosition,
    @Default(50) int totalItems,
  }) = _AutoScrollState;
}