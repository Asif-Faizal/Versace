import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState.home());
  
  BottomNavState? _previousState;

  void select(BottomNavState state) {
    if (state is SearchNav) {
      _previousState = this.state is SearchNav ? _previousState : this.state;
    }
    emit(state);
  }
  
  BottomNavState? get previousState => _previousState;
} 