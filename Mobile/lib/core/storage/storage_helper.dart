import 'package:hive_ce_flutter/hive_flutter.dart';

class StorageHelper {
  static const String _themeBoxName = 'theme_box';
  static const String _isDarkModeKey = 'is_dark_mode';
  
  // Auth box constants
  static const String _authBoxName = 'auth_box';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Device info box constants
  static const String _deviceInfoBoxName = 'device_info_box';
  static const String _deviceIdKey = 'device_id';
  static const String _deviceModelKey = 'device_model';
  static const String _deviceManufacturerKey = 'device_manufacturer';
  static const String _deviceOsKey = 'device_os';
  static const String _deviceOsVersionKey = 'device_os_version';

  Future<void> init() async {
    await Hive.openBox<bool>(_themeBoxName);
    await Hive.openBox<String>(_authBoxName);
    await Hive.openBox<String>(_deviceInfoBoxName);
  }

  Box<bool> get _themeBox => Hive.box<bool>(_themeBoxName);
  Box<String> get _authBox => Hive.box<String>(_authBoxName);
  Box<String> get _deviceInfoBox => Hive.box<String>(_deviceInfoBoxName);
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

  // Device info methods
  Future<void> setDeviceInfo({
    required String deviceId,
    required String deviceModel,
    required String deviceManufacturer,
    required String deviceOs,
    required String deviceOsVersion,
  }) async {
    await _deviceInfoBox.put(_deviceIdKey, deviceId);
    await _deviceInfoBox.put(_deviceModelKey, deviceModel);
    await _deviceInfoBox.put(_deviceManufacturerKey, deviceManufacturer);
    await _deviceInfoBox.put(_deviceOsKey, deviceOs);
    await _deviceInfoBox.put(_deviceOsVersionKey, deviceOsVersion);
  }

  String? get deviceId => _deviceInfoBox.get(_deviceIdKey);

  String? get deviceModel => _deviceInfoBox.get(_deviceModelKey);

  String? get deviceManufacturer => _deviceInfoBox.get(_deviceManufacturerKey);

  String? get deviceOs => _deviceInfoBox.get(_deviceOsKey);

  String? get deviceOsVersion => _deviceInfoBox.get(_deviceOsVersionKey);

  Future<void> clearDeviceInfo() async {
    await _deviceInfoBox.deleteAll([
      _deviceIdKey,
      _deviceModelKey,
      _deviceManufacturerKey,
      _deviceOsKey,
      _deviceOsVersionKey,
    ]);
  }
} 