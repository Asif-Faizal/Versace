import 'package:flutter_bloc/flutter_bloc.dart';

import 'password_visibility_login_state.dart';

class PasswordVisibilityLoginCubit extends Cubit<PasswordVisibilityLoginState> {
  PasswordVisibilityLoginCubit() : super(const PasswordVisibilityLoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
} 