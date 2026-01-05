/// Application-wide constants
class AppConstants {
  const AppConstants._();

  // API Config
  static const Duration apiConnectTimeout = Duration(seconds: 20);
  static const Duration apiReceiveTimeout =
      Duration(seconds: 60); // Increased from 15s to allow for AI analysis
}
