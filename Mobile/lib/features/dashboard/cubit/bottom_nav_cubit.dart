import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState.home());
  
  BottomNavState? _previousState;

  void select(BottomNavState state) {
    if (state is SearchNav || state is EditProfileNav) {
      _previousState = this.state is SearchNav || this.state is EditProfileNav ? _previousState : this.state;
    }
    emit(state);
  }
  
  void goHome() {
    if (_previousState != null) {
      emit(_previousState!);
      _previousState = null;
    } else {
      emit(const BottomNavState.home());
    }
  }
  
  BottomNavState? get previousState => _previousState;
} 