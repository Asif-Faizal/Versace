import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/core/routing/routing_constants.dart';
import 'package:versace/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:versace/features/splash/presentation/screens/splash_screen.dart';

import '../../features/dashboard/cubit/bottom_nav_cubit.dart';
import '../../features/dashboard/cubit/bottom_nav_state.dart';
import '../../features/register/presentation/screens/enter_password_screen.dart';
import '../../features/register/presentation/screens/register_user_screen.dart';
import '../../features/splash/presentation/screens/initial_screen.dart';
import 'routing_arguments.dart';

/// Generates routes for the app using the route name and arguments
class RouteGenerator {
  /// Route generation method that returns the appropriate route
  static Route<dynamic> generateRoute(RouteSettings settings, BuildContext context) {
    // Get arguments passed to the route
    final args = settings.arguments;

    switch (settings.name) {
      case RouteConstants.splash:
        return _buildRoute(const SplashScreen(), settings);
      case RouteConstants.initial:
        return _buildRoute(const InitialScreen(), settings);
      case RouteConstants.home:
        final navCubit = context.read<BottomNavCubit>();
        navCubit.select(const BottomNavState.home());
        return _buildRoute(const DashboardScreen(), settings);
      case RouteConstants.favorites:
        final navCubit = context.read<BottomNavCubit>();
        navCubit.select(const BottomNavState.favorites());
        return _buildRoute(const DashboardScreen(), settings);
      case RouteConstants.cart:
        final navCubit = context.read<BottomNavCubit>();
        navCubit.select(const BottomNavState.cart());
        return _buildRoute(const DashboardScreen(), settings);
      case RouteConstants.profile:
        final navCubit = context.read<BottomNavCubit>();
        navCubit.select(const BottomNavState.profile());
        return _buildRoute(const DashboardScreen(), settings);
      case RouteConstants.search:
        final navCubit = context.read<BottomNavCubit>();
        navCubit.select(const BottomNavState.search());
        return _buildRoute(const DashboardScreen(), settings);
      case RouteConstants.registerUser:
        return _buildRoute(const RegisterUserScreen(), settings);
      case RouteConstants.enterPassword:
        if (args is EnterPasswordArguments) {
          return _buildRoute(EnterPasswordScreen(arguments: args), settings);
        }
        return _errorRoute('Error', context);
      default:
        return _errorRoute('Error', context);
    }
  }
  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Helper method to create an error route
  static Route<dynamic> _errorRoute(String message, BuildContext context) {
    return MaterialPageRoute(builder: (context) => const Scaffold(
      body: Center(
        child: Text('Error'),
      ),
    ));
  }
}
