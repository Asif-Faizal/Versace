import 'package:bloc/bloc.dart';

import '../../data/register/model/register_request_model.dart';
import '../../domain/register/register.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;
  RegisterBloc({required this.registerUsecase})
    : super(RegisterState.initial()) {
    on<RegisterEvent>(_onRegisterEvent);
  }

  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterState.loading());
    final result = await registerUsecase.execute(
      RegisterRequestModel(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
      ),
    );
    result.fold(
      (failure) => emit(RegisterState.error(failure.toString())),
      (registerEntity) => emit(RegisterState.success(registerEntity)),
    );
  }
}
