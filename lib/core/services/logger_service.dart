import 'package:flutter/foundation.dart';

/// Service for structured logging.
/// Use this instead of print() or debugPrint().
class LogService {
  static final LogService _instance = LogService._internal();

  factory LogService() {
    return _instance;
  }

  LogService._internal();

  /// Log debug message (development only)
  void d(String message) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
    }
  }

  /// Log info message (general flow events)
  void i(String message) {
    debugPrint('[INFO] $message');
    // TODO: Send to Crashlytics as log
  }

  /// Log warning (non-fatal errors)
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('[WARN] $message');
    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('Stack: $stackTrace');
    // TODO: Send to Crashlytics as non-fatal
  }

  /// Log error (fatal errors)
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message');
    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('Stack: $stackTrace');
    // TODO: Send to Crashlytics as fatal
  }
}
