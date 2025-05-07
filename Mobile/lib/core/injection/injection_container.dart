import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:versace/core/storage/storage_helper.dart';
import 'package:versace/core/theme/cubit/theme_cubit.dart';

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
}
