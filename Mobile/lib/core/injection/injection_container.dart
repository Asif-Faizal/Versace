import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:versace/core/storage/storage_helper.dart';
import 'package:versace/core/theme/cubit/theme_cubit.dart';
import 'package:versace/features/dashboard/cubit/auto_scroll_cubit.dart';
import 'package:versace/features/dashboard/cubit/bottom_nav_cubit.dart';
import 'package:http/http.dart' as http;

import '../../features/login/bloc/login/login_bloc.dart';
import '../../features/login/cubit/password_visibility/password_visibility_login_cubit.dart';
import '../../features/login/data/login/login_datasource.dart';
import '../../features/login/data/login/login_repo_impl.dart';
import '../../features/login/domain/login/login.dart';
import '../../features/login/domain/login/login_repo.dart';
import '../../features/register/bloc/email_verification/email_verification_bloc.dart';
import '../../features/register/data/email_verification/email_verification_datasource.dart';
import '../../features/register/data/email_verification/email_verification_repo_impl.dart';
import '../../features/register/domain/email_verification/email_verification_repo.dart';
import '../../features/register/domain/email_verification/usecases/sent_email_otp.dart';
import '../../features/register/domain/email_verification/usecases/verify_email_otp.dart';
import '../../features/register/presentation/cubits/password_visibility_cubit.dart';
import '../../features/splash/cubit/splash/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Storage
  getIt.registerLazySingleton<StorageHelper>(() => StorageHelper());

  // Initialize storage
  await getIt<StorageHelper>().init();

  // Cubits
  getIt.registerFactory(() => ThemeCubit(getIt<StorageHelper>()));
  getIt.registerFactory(() => SplashCubit());
  getIt.registerFactory(() => PasswordVisibilityCubit());
  getIt.registerFactory(() => PasswordVisibilityLoginCubit());

  // Factory for AutoScrollCubit
  getIt.registerFactory(() => AutoScrollCubit(
    scrollDuration: const Duration(milliseconds: 30),
    itemWidth: 400,
  ));

  // Register BottomNavCubit as a singleton
  getIt.registerLazySingleton<BottomNavCubit>(() => BottomNavCubit());

  // HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Email Verification
  getIt.registerLazySingleton<EmailVerificationRepository>(() => EmailVerificationRepositoryImpl(dataSource: getIt<EmailVerificationDataSource>()));
  getIt.registerLazySingleton<EmailVerificationDataSource>(() => EmailVerificationDataSourceImpl(client: getIt<http.Client>()));
  getIt.registerLazySingleton<SentEmailOtpUsecase>(() => SentEmailOtpUsecase(repository: getIt<EmailVerificationRepository>()));
  getIt.registerLazySingleton<VerifyEmailOtpUsecase>(() => VerifyEmailOtpUsecase(repository: getIt<EmailVerificationRepository>()));
  getIt.registerLazySingleton<EmailVerificationBloc>(() => EmailVerificationBloc(
    sentEmailOtpUsecase: getIt<SentEmailOtpUsecase>(),
    verifyEmailOtpUsecase: getIt<VerifyEmailOtpUsecase>(),
  ));


  // Login
  getIt.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl(client: getIt<http.Client>()));
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(remoteDataSource: getIt<LoginRemoteDataSource>()));
  getIt.registerLazySingleton<LoginUsecase>(() => LoginUsecase(repository: getIt<LoginRepository>()));
  getIt.registerLazySingleton<LoginBloc>(() => LoginBloc(loginUsecase: getIt<LoginUsecase>()));
}
