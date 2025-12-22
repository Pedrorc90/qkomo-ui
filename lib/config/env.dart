enum Environment {
  local,
  uat,
  prod,
}

class EnvConfig {
  static const appEnv =
      String.fromEnvironment('APP_ENV', defaultValue: 'local');

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

  /// Feature flag to enable/disable cloud sync
  static bool get enableCloudSync {
    return const bool.fromEnvironment(
      'ENABLE_CLOUD_SYNC',
    );
  }

  /// Sync frequency in minutes (default: 30 minutes)
  static int get syncFrequencyMinutes {
    return const int.fromEnvironment(
      'SYNC_FREQUENCY_MINUTES',
      defaultValue: 30,
    );
  }

  /// Whether to sync only on Wi-Fi (default: false, sync on any connection)
  static bool get syncOnlyOnWifi {
    return const bool.fromEnvironment(
      'SYNC_ONLY_ON_WIFI',
    );
  }
}
