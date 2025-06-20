import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:versace/core/injection/injection_container.dart' as di;
import 'package:versace/core/routing/routing_constants.dart';
import 'package:versace/core/routing/routing_generator.dart';
import 'package:versace/core/routing/routing_service.dart';
import 'package:versace/core/storage/storage_helper.dart';
import 'package:versace/core/theme/app_theme.dart';
import 'package:versace/core/theme/cubit/theme_cubit.dart';
import 'package:versace/core/theme/cubit/theme_state.dart';
import 'package:versace/features/splash/cubit/splash/splash_cubit.dart';

import 'core/api/enviornment.config.dart';
import 'core/api/api.config.dart';
import 'features/dashboard/bloc/user_details/user_details_bloc.dart';
import 'features/dashboard/cubit/bottom_nav_cubit.dart';
import 'features/login/bloc/login/login_bloc.dart';
import 'features/login/cubit/password_visibility/password_visibility_login_cubit.dart';
import 'features/register/bloc/email_verification/email_verification_bloc.dart';
import 'features/register/bloc/register/register_bloc.dart';
import 'features/register/presentation/cubits/password_visibility_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvironmentConfig.setEnvironment(Environment.development);
  await ApiConfig.loadEnv();
  await di.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Provider<StorageHelper>(
      create: (_) => di.getIt<StorageHelper>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => di.getIt<ThemeCubit>(),
          ),
          BlocProvider(
            create: (_) => di.getIt<SplashCubit>(),
          ),
          BlocProvider(
            create: (_) => di.getIt<BottomNavCubit>(),
          ),
          BlocProvider(
            create: (_) => di.getIt<EmailVerificationBloc>(),
          ),
          BlocProvider(
            create: (_) => di.getIt<PasswordVisibilityCubit>(),
          ),
          BlocProvider(
            create: (_) => di.getIt<PasswordVisibilityLoginCubit>(),
          ),
          BlocProvider(
            create: (_) => di.getIt<LoginBloc>(),
          ),
          BlocProvider(
            create: (_) => di.getIt<RegisterBloc>(),
          ),
          BlocProvider(
            create: (_) => di.getIt<UserDetailsBloc>(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Versace',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              navigatorKey: NavigationService().navigatorKey,
              initialRoute: RouteConstants.splash,
              onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings, context),
            );
          },
        ),
      ),
    );
  }
}