import 'package:bloc/bloc.dart';

import '../../data/login/models/login_request_model.dart';
import '../../domain/login/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc({required this.loginUsecase}) : super(const LoginState.initial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<LoginState> emit) async {
    emit(const LoginState.loading());
    final result = await loginUsecase.execute(LoginRequestModel(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(LoginState.error(failure.toString())),
      (entity) => emit(LoginState.success(entity)),
    );
  }
}