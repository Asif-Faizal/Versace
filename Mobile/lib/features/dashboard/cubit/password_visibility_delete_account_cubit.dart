import 'package:flutter_bloc/flutter_bloc.dart';
import 'password_visibility_delete_account_state.dart';

class PasswordVisibilityDeleteAccountCubit extends Cubit<PasswordVisibilityDeleteAccountState> {
  PasswordVisibilityDeleteAccountCubit() : super(const PasswordVisibilityDeleteAccountState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
} 