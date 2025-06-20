enum Environment {
  simulator,
  development,
  production
}

class EnvironmentConfig {
  static Environment _environment = Environment.simulator;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static Environment get environment => _environment;

  static bool get issimulator => _environment == Environment.simulator;
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isProduction => _environment == Environment.production;
} 