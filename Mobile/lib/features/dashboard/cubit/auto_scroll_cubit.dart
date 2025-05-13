import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class AutoScrollState {
  final bool isScrolling;
  final double scrollPosition;
  final int totalItems;

  const AutoScrollState({
    this.isScrolling = true,
    this.scrollPosition = 0.0,
    this.totalItems = 50,
  });

  AutoScrollState copyWith({
    bool? isScrolling,
    double? scrollPosition,
    int? totalItems,
  }) {
    return AutoScrollState(
      isScrolling: isScrolling ?? this.isScrolling,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class AutoScrollCubit extends Cubit<AutoScrollState> {
  final ScrollController scrollController = ScrollController();
  Timer? _scrollTimer;
  final Duration scrollDuration;
  final double itemWidth;

  AutoScrollCubit({
    this.scrollDuration = const Duration(milliseconds: 30),
    this.itemWidth = 400,
  }) : super(const AutoScrollState()) {
    _startScrolling();
  }

  void _startScrolling() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(scrollDuration, (_) {
      if (!state.isScrolling || !scrollController.hasClients) return;

      final currentPosition = scrollController.position.pixels;
      final maxExtent = scrollController.position.maxScrollExtent;
      
      // Add small increment for smooth scrolling
      final nextPosition = currentPosition + 2;
      
      // Reset to beginning when reaching the end
      if (nextPosition >= maxExtent) {
        scrollController.jumpTo(0);
        emit(state.copyWith(scrollPosition: 0));
      } else {
        scrollController.jumpTo(nextPosition);
        emit(state.copyWith(scrollPosition: nextPosition));
      }
    });
  }

  void pauseScrolling() {
    _scrollTimer?.cancel();
    emit(state.copyWith(isScrolling: false));
  }

  void resumeScrolling() {
    if (!state.isScrolling) {
      emit(state.copyWith(isScrolling: true));
      _startScrolling();
    }
  }

  void resetScrollPosition() {
    scrollController.jumpTo(0);
    emit(state.copyWith(scrollPosition: 0));
  }

  @override
  Future<void> close() {
    _scrollTimer?.cancel();
    scrollController.dispose();
    return super.close();
  }
} 