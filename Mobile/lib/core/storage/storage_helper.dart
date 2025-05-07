import 'package:hive_ce_flutter/hive_flutter.dart';

class StorageHelper {
  static const String _themeBoxName = 'theme_box';
  static const String _isDarkModeKey = 'is_dark_mode';

  Future<void> init() async {
    await Hive.openBox<bool>(_themeBoxName);
  }

  Box<bool> get _themeBox => Hive.box<bool>(_themeBoxName);

  bool get isDarkMode => _themeBox.get(_isDarkModeKey) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _themeBox.put(_isDarkModeKey, value);
  }
} 