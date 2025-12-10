/// Application-wide constants
class AppConstants {
  const AppConstants._();

  // API Config
  static const Duration apiConnectTimeout = Duration(seconds: 5);
  static const Duration apiReceiveTimeout = Duration(seconds: 15);

  // Queue Config
  static const Duration queueSuccessTtl = Duration(days: 7);
  static const int maxQueueRetries = 3;
  static const Duration maxBackoffDelay = Duration(milliseconds: 30000); // 30s
}
