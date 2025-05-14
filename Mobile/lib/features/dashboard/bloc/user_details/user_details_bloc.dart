import 'package:bloc/bloc.dart';

import '../../domain/user_details/usecases/get_user_details.dart';
import '../../domain/user_details/usecases/update_user_details.dart';
import '../../domain/user_details/usecases/user_logout.dart';
import 'user_details_event.dart';
import 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final GetUserDetailsUsecase getUserDetailsUsecase;
  final UpdateUserDetailsUsecase updateUserDetailsUsecase;
  final UserLogoutUsecase userLogoutUsecase;
  UserDetailsBloc({required this.getUserDetailsUsecase, required this.updateUserDetailsUsecase, required this.userLogoutUsecase}) : super(UserDetailsState.initial()) {
    on<UserDetailsRequested>(_onUserDetailsRequested);
    on<UpdateUserDetailsRequested>(_onUpdateUserDetailsRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onUserDetailsRequested(UserDetailsRequested event, Emitter<UserDetailsState> emit) async {
    emit(UserDetailsState.loading());
    final result = await getUserDetailsUsecase.execute(null);
    result.fold(
      (failure) => emit(UserDetailsState.error(failure.toString())),
      (userDetails) => emit(UserDetailsState.success(userDetails)),
    );
  }

  void _onUpdateUserDetailsRequested(UpdateUserDetailsRequested event, Emitter<UserDetailsState> emit) async {
    emit(UserDetailsState.loading());
    final result = await updateUserDetailsUsecase.execute(event.updateUserRequestModel);
    result.fold(
      (failure) => emit(UserDetailsState.error(failure.toString())),
      (userDetails) => emit(UserDetailsState.updateSuccess(userDetails)),
    );
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<UserDetailsState> emit) async {
    emit(UserDetailsState.logoutLoading());
    final result = await userLogoutUsecase.execute(null);
    result.fold(
      (failure) => emit(UserDetailsState.logoutFailure(failure.toString())),
      (userDetails) => emit(UserDetailsState.logoutSuccess()),
    );
  }
}