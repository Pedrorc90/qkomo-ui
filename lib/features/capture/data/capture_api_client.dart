import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/analyze_response_dto.dart';

class CaptureApiClient {
  CaptureApiClient({
    required Dio dio,
    required FirebaseAuth auth,
  })  : _dio = dio,
        _auth = auth;

  final Dio _dio;
  final FirebaseAuth _auth;

  Future<AnalyzeResponseDto> analyzeImage({
    required String path,
    String? type,
  }) async {
    if (!await File(path).exists()) {
      throw Exception('El archivo de imagen no existe en $path');
    }
    final token = await _requireIdToken();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(path),
      if (type != null && type.isNotEmpty) 'type': type,
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/analyze',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return AnalyzeResponseDto.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<AnalyzeResponseDto> analyzeBarcode(String barcode) async {
    final token = await _requireIdToken();
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/analyze/barcode',
      data: {'barcode': barcode},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return AnalyzeResponseDto.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<String> _requireIdToken() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado; inicia sesión para analizar.');
    }
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw Exception('No se pudo obtener el token de Firebase.');
    }
    return token;
  }
}
