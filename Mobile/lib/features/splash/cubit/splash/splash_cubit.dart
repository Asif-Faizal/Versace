import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/features/splash/cubit/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {

  SplashCubit() : super(const SplashState()) {
    _startAnimation();
  }

  void _startAnimation() async {
    emit(SplashState(type: SplashStateType.initial));

    // Start typing animation
    emit(SplashState(type: SplashStateType.typing));
    
    // Wait for typing animation (2 seconds)
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Show image animation
    emit(SplashState(type: SplashStateType.showingImage));
    
    // Wait for image animation (1 second)
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Complete animation
    emit(SplashState(type: SplashStateType.completed));
  }
}
