import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_scroll_state.freezed.dart';

@freezed
class AutoScrollState with _$AutoScrollState {
  const factory AutoScrollState({
    @Default(0) int currentIndex,
    @Default(false) bool isScrolling,
    @Default(0) int totalItems,
    @Default(0.0) double textWidth,
  }) = _AutoScrollState;
} 