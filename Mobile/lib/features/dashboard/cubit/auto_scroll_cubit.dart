import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'auto_scroll_state.dart';

class AutoScrollCubit extends Cubit<AutoScrollState> {
  final ScrollController scrollController;
  Timer? _scrollTimer;
  Timer? _updateTimer;
  bool _isDisposed = false;
  final Duration scrollDuration;
  final double itemWidth;
  double _textWidth;
  int _visibleItems = 1;
  double _currentOffset = 0;
  bool _isScrolling = true;

  AutoScrollCubit({
    required this.scrollController,
    required double textWidth,
    this.scrollDuration = const Duration(milliseconds: 1000),
    this.itemWidth = 400,
  }) : _textWidth = textWidth,
       super(const AutoScrollState()) {
    emit(state.copyWith(
      totalItems: 1,
      textWidth: textWidth,
    ));
    _calculateVisibleItems();
    _startScrollTimer();
    _startUpdateTimer();
  }

  void _calculateVisibleItems() {
    if (!scrollController.hasClients || itemWidth <= 0) {
      emit(state.copyWith(totalItems: 1));
      return;
    }

    try {
      final screenWidth = scrollController.position.viewportDimension;
      if (screenWidth <= 0) {
        emit(state.copyWith(totalItems: 1));
        return;
      }

      _visibleItems = (screenWidth / itemWidth).ceil() + 1;
      if (_visibleItems <= 0) {
        _visibleItems = 1;
      }

      emit(state.copyWith(
        totalItems: _visibleItems,
        textWidth: _textWidth,
      ));
    } catch (e) {
      emit(state.copyWith(totalItems: 1));
    }
  }

  // Separate timer for continuous scrolling (no UI updates)
  void _startScrollTimer() {
    if (_scrollTimer != null) {
      _scrollTimer?.cancel();
    }

    const scrollStep = 2.0;
    const updateInterval = Duration(milliseconds: 16); // 60 FPS

    _scrollTimer = Timer.periodic(updateInterval, (timer) {
      if (_isDisposed || !scrollController.hasClients || !_isScrolling) {
        return;
      }

      try {
        _currentOffset += scrollStep;
        final maxScroll = itemWidth * _visibleItems;
        
        if (_currentOffset >= maxScroll) {
          _currentOffset = 0;
          scrollController.jumpTo(0);
        } else {
          scrollController.jumpTo(_currentOffset);
        }
      } catch (e) {
        pauseScrolling();
      }
    });
  }

  // Separate timer for UI updates (very infrequent)
  void _startUpdateTimer() {
    if (_updateTimer != null) {
      _updateTimer?.cancel();
    }

    // Update UI much less frequently (every 3 seconds)
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isDisposed || !_isScrolling) {
        return;
      }

      try {
        if (scrollController.hasClients) {
          final currentIndex = (_currentOffset / itemWidth).floor() % _visibleItems;
          emit(state.copyWith(
            currentIndex: currentIndex,
            isScrolling: true,
          ));
        }
      } catch (e) {
        // Ignore UI update errors
      }
    });
  }

  void pauseScrolling() {
    _isScrolling = false;
    _scrollTimer?.cancel();
    _updateTimer?.cancel();
    emit(state.copyWith(isScrolling: false));
  }

  void resumeScrolling() {
    if (!_isScrolling) {
      _isScrolling = true;
      _startScrollTimer();
      _startUpdateTimer();
    }
  }

  void updateTextWidth(double newWidth) {
    if (newWidth != _textWidth) {
      _textWidth = newWidth;
      emit(state.copyWith(textWidth: newWidth));
      _calculateVisibleItems();
    }
  }

  @override
  Future<void> close() {
    _isDisposed = true;
    _scrollTimer?.cancel();
    _updateTimer?.cancel();
    scrollController.dispose();
    return super.close();
  }
} 