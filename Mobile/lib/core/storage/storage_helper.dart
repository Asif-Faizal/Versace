import 'package:hive_ce_flutter/hive_flutter.dart';

class StorageHelper {
  static const String _themeBoxName = 'theme_box';
  static const String _isDarkModeKey = 'is_dark_mode';
  
  // Auth box constants
  static const String _authBoxName = 'auth_box';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> init() async {
    await Hive.openBox<bool>(_themeBoxName);
    await Hive.openBox<String>(_authBoxName);
  }

  Box<bool> get _themeBox => Hive.box<bool>(_themeBoxName);
  Box<String> get _authBox => Hive.box<String>(_authBoxName);

  // Theme methods
  bool get isDarkMode => _themeBox.get(_isDarkModeKey) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _themeBox.put(_isDarkModeKey, value);
  }

  // Auth methods
  bool get isLoggedIn => _authBox.get(_isLoggedInKey) == 'true';

  String? get accessToken => _authBox.get(_accessTokenKey);

  String? get refreshToken => _authBox.get(_refreshTokenKey);

  Future<void> setAuthData({
    required bool isLoggedIn,
    String? accessToken,
    String? refreshToken,
  }) async {
    await _authBox.put(_isLoggedInKey, isLoggedIn.toString());
    if (accessToken != null) {
      await _authBox.put(_accessTokenKey, accessToken);
    }
    if (refreshToken != null) {
      await _authBox.put(_refreshTokenKey, refreshToken);
    }
  }

  Future<void> clearAuthData() async {
    await _authBox.deleteAll([
      _isLoggedInKey,
      _accessTokenKey,
      _refreshTokenKey,
    ]);
  }
} 