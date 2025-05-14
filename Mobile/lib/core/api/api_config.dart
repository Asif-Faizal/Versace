import 'package:flutter/services.dart' show rootBundle;
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
    try {
      final content = await rootBundle.loadString(envFileName);
      for (final line in content.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.startsWith('BASE_URL')) {
          final parts = trimmed.split('=');
          if (parts.length == 2) {
            baseUrl = parts[1].trim().replaceAll('\"', '');
            print('Loaded BASE_URL: $baseUrl');
          }
        }
      }
    } catch (e) {
      print('Env file not found or error reading: $e');
    }
  }
}
