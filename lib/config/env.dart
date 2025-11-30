enum Environment {
  local,
  uat,
  prod,
}

class EnvConfig {
  static const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'local');

  static Environment get environment {
    switch (appEnv) {
      case 'uat':
        return Environment.uat;
      case 'prod':
        return Environment.prod;
      case 'local':
      default:
        return Environment.local;
    }
  }

  static String get baseUrl {
    switch (environment) {
      case Environment.local:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:8080',
        );
      case Environment.uat:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api-uat.qkomo.com',
        );
      case Environment.prod:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.qkomo.com',
        );
    }
  }
}
