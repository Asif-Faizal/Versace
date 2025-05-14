import 'package:bloc/bloc.dart';

import '../../domain/user_details/usecases/get_user_details.dart';
import 'user_details_event.dart';
import 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final GetUserDetailsUsecase getUserDetailsUsecase;
  UserDetailsBloc({required this.getUserDetailsUsecase}) : super(UserDetailsState.initial()) {
    on<UserDetailsEvent>(_onUserDetailsEvent);
  }

  void _onUserDetailsEvent(UserDetailsEvent event, Emitter<UserDetailsState> emit) {
    event.map(
      userDetailsRequested: (e) => _onUserDetailsRequested(e, emit),
    );
  }

  void _onUserDetailsRequested(UserDetailsRequested event, Emitter<UserDetailsState> emit) async {
    emit(UserDetailsState.loading());
    final result = await getUserDetailsUsecase.execute(null);
    result.fold(
      (failure) => emit(UserDetailsState.error(failure.toString())),
      (userDetails) => emit(UserDetailsState.success(userDetails)),
    );
  }
}
