import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:versace/core/storage/storage_helper.dart';
import 'package:versace/core/theme/cubit/theme_cubit.dart';
import 'package:versace/features/dashboard/cubit/auto_scroll_cubit.dart';
import 'package:versace/features/dashboard/cubit/bottom_nav_cubit.dart';

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
  
  // Factory for AutoScrollCubit
  getIt.registerFactory(() => AutoScrollCubit(
    scrollDuration: const Duration(milliseconds: 30),
    itemWidth: 400,
  ));

  // Register BottomNavCubit as a singleton
  getIt.registerLazySingleton<BottomNavCubit>(() => BottomNavCubit());
}
