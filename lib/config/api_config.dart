class ApiConfig {
  /// Backend base URL for API calls. Override with `--dart-define=API_BASE_URL=https://...`.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}
