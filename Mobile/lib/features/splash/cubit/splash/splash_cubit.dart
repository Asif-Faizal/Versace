import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:versace/features/splash/cubit/splash/splash_state.dart';
import 'package:versace/core/injection/injection_container.dart' as di;
import '../../../../core/storage/storage_helper.dart';

class SplashCubit extends Cubit<SplashState> {
  static const platform = MethodChannel('com.example.versace/device');

  SplashCubit() : super(const SplashState()) {
    _startAnimation();
  }

  Future<Map<String, dynamic>?> _getDeviceInfo() async {
    try {
      final String? deviceInfoJson = await platform.invokeMethod(
        'getDeviceInfo',
      );
      if (deviceInfoJson != null) {
        debugPrint('Device info: $deviceInfoJson');
        final deviceInfo = json.decode(deviceInfoJson) as Map<String, dynamic>;
        final StorageHelper storageHelper = di.getIt<StorageHelper>();
        await storageHelper.setDeviceInfo(
          deviceId: deviceInfo['deviceId'],
          deviceModel: deviceInfo['model'],
          deviceManufacturer: deviceInfo['manufacturer'],
          deviceOs: deviceInfo['os'],
          deviceOsVersion: deviceInfo['osVersion'],
        );
      }
      return null;
    } on PlatformException catch (e) {
      debugPrint('Failed to get device info: ${e.message}');
      return null;
    }
  }

  void _startAnimation() async {
    emit(SplashState(type: SplashStateType.initial));

    // Get device info
    final deviceInfo = await _getDeviceInfo();
    emit(
      SplashState(
        type: SplashStateType.initial,
        deviceId: deviceInfo?['deviceId'],
        deviceModel: deviceInfo?['model'],
        deviceManufacturer: deviceInfo?['manufacturer'],
        deviceOs: deviceInfo?['os'],
        deviceOsVersion: deviceInfo?['osVersion'],
      ),
    );

    // Start typing animation
    emit(
      SplashState(
        type: SplashStateType.typing,
        deviceId: deviceInfo?['deviceId'],
        deviceModel: deviceInfo?['model'],
        deviceManufacturer: deviceInfo?['manufacturer'],
        deviceOs: deviceInfo?['os'],
        deviceOsVersion: deviceInfo?['osVersion'],
      ),
    );

    // Wait for typing animation
    await Future.delayed(const Duration(milliseconds: 800));

    // Show image animation
    emit(
      SplashState(
        type: SplashStateType.showingImage,
        deviceId: deviceInfo?['deviceId'],
        deviceModel: deviceInfo?['model'],
        deviceManufacturer: deviceInfo?['manufacturer'],
        deviceOs: deviceInfo?['os'],
        deviceOsVersion: deviceInfo?['osVersion'],
      ),
    );

    // Wait for image animation
    await Future.delayed(const Duration(milliseconds: 1500));

    // Complete animation
    emit(
      SplashState(
        type: SplashStateType.completed,
        deviceId: deviceInfo?['deviceId'],
        deviceModel: deviceInfo?['model'],
        deviceManufacturer: deviceInfo?['manufacturer'],
        deviceOs: deviceInfo?['os'],
        deviceOsVersion: deviceInfo?['osVersion'],
      ),
    );
  }
}
