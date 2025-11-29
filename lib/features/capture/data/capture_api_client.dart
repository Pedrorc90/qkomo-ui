import 'dart:io';

import 'package:dio/dio.dart';

import 'models/analyze_response_dto.dart';

class CaptureApiClient {
  CaptureApiClient({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  Future<AnalyzeResponseDto> analyzeImage({
    required String path,
    String? type,
  }) async {
    if (!await File(path).exists()) {
      throw Exception('El archivo de imagen no existe en $path');
    }
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(path),
      if (type != null && type.isNotEmpty) 'type': type,
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/analyze',
      data: formData,
    );
    return AnalyzeResponseDto.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<AnalyzeResponseDto> analyzeBarcode(String barcode) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/analyze/barcode',
      data: {'barcode': barcode},
    );
    return AnalyzeResponseDto.fromJson(response.data ?? <String, dynamic>{});
  }
}

