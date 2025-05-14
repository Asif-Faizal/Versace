import 'dart:io';
import 'enviornment_config.dart';

class ApiConfig {
  static String? baseUrl;

  static Future<void> loadEnv() async {
    String envFileName;
    switch (EnvironmentConfig.environment) {
      case Environment.simulator:
        envFileName = '.env.simulator';
        break;
      case Environment.development:
        envFileName = '.env.development';
        break;
      case Environment.production:
        envFileName = '.env.production';
        break;
    }
    final file = File('Mobile/$envFileName');
    if (await file.exists()) {
      final lines = await file.readAsLines();
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.startsWith('BASE_URL')) {
          final parts = trimmed.split('=');
          if (parts.length == 2) {
            baseUrl = parts[1].trim().replaceAll('"', '');
          }
        }
      }
    }
  }
}
