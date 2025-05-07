import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/core/storage/storage_helper.dart';
import 'package:versace/core/theme/cubit/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final StorageHelper _storageHelper;

  ThemeCubit(this._storageHelper) : super(const ThemeState()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDarkMode = _storageHelper.isDarkMode;
    emit(ThemeState(isDarkMode: isDarkMode));
  }

  Future<void> toggleTheme() async {
    final newIsDarkMode = !state.isDarkMode;
    await _storageHelper.setDarkMode(newIsDarkMode);
    emit(ThemeState(isDarkMode: newIsDarkMode));
  }
} 