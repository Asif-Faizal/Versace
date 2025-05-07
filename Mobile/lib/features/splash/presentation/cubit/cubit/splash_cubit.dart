import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/features/splash/presentation/cubit/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState()) {
    _startAnimation();
  }

  void _startAnimation() async {
    // Start typing animation
    emit(const SplashState(type: SplashStateType.typing));
    
    // Wait for typing animation (2 seconds)
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Show image animation
    emit(const SplashState(type: SplashStateType.showingImage));
    
    // Wait for image animation (1 second)
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Complete animation
    emit(const SplashState(type: SplashStateType.completed));
  }
}
