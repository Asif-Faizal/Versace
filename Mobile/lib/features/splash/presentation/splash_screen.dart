import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/features/dashboard/presentation/home_screen.dart';
import 'package:versace/features/splash/presentation/cubit/cubit/splash_cubit.dart';
import 'package:versace/features/splash/presentation/cubit/cubit/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.type == SplashStateType.completed) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        builder: (context, state) {
          final logo = Theme.of(context).brightness == Brightness.dark 
              ? 'lib/assets/images/logo-white.png' 
              : 'lib/assets/images/logo-black.png';
          
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: state.type == SplashStateType.showingImage || 
                            state.type == SplashStateType.completed ? 1.0 : 0.0,
                    child: Hero(tag: 'logo', child: Image.asset(logo, width: 150, height: 150)),
                  ),
                  const SizedBox(height: 5),
                  Hero(tag: 'title', child: Material(color: Colors.transparent,child: _buildTypingText(context, state))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypingText(BuildContext context, SplashState state) {
    final text = 'VERSACE';
    final textStyle = Theme.of(context).textTheme.displayMedium;

    // Create a TextPainter to measure the text width
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final totalWidth = textPainter.width + 40; // Add padding

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: totalWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.type == SplashStateType.typing) ...[
            ...List.generate(text.length, (index) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 * (index + 1)),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Text(
                      text[index],
                      style: textStyle,
                    ),
                  );
                },
              );
            }),
          ] else
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: state.type == SplashStateType.typing ? 0.0 : 1.0,
              child: Text(text, style: textStyle),
            ),
        ],
      ),
    );
  }
}