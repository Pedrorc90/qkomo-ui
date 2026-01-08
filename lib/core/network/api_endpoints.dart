/// Centralized API endpoints for backend communication
///
/// This class provides a single source of truth for all API endpoints used in the app.
/// Use static constants for base endpoints and factory methods for parameterized ones.
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();

  // Profile endpoints
  static const String userProfile = '/api/v1/users/me';

  // Companion endpoints
  static const String companions = '/v1/companions';
  static String companionById(String id) => '/v1/companions/$id';

  // Settings endpoints
  static const String preferences = '/v1/preferences';

  // Feature toggles endpoints
  static const String features = '/api/features';

  // Meal endpoints
  static const String meals = '/v1/meals';
  static String mealById(String id) => '/v1/meals/$id';
}
