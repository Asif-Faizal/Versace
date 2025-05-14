import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpFocusCubit extends Cubit<void> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  OtpFocusCubit() : super(null);

  void moveToNext(int index) {
    if (index < focusNodes.length - 1) {
      focusNodes[index + 1].requestFocus();
    } else {
      focusNodes[index].unfocus();
    }
    emit(null);
  }

  void moveToPrevious(int index) {
    if (index > 0) {
      focusNodes[index - 1].requestFocus();
    }
    emit(null);
  }

  void clearField(int index) {
    controllers[index].clear();
    emit(null);
  }

  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
  }
} 