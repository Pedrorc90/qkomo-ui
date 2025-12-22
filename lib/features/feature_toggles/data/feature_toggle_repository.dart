import 'package:dio/dio.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle.dart';

class FeatureToggleRepository {
  final Dio _dio;

  FeatureToggleRepository(this._dio);

  Future<List<FeatureToggle>> getFeatureToggles() async {
    try {
      final response = await _dio.get('/api/features');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => FeatureToggle.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Return empty list on error to avoid blocking the app
      return [];
    }
  }
}
