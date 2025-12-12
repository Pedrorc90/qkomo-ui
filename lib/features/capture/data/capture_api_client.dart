import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:qkomo_ui/features/capture/data/models/analyze_response_dto.dart';

class CaptureApiClient {
  CaptureApiClient({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  Future<AnalyzeResponseDto> analyzeImage({
    required XFile file,
    String? type,
  }) async {
    late MultipartFile multipartFile;

    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      multipartFile = MultipartFileRecreatable.fromBytes(
        bytes,
        filename: file.name,
      );
    } else {
      if (!await File(file.path).exists()) {
        throw Exception('El archivo de imagen no existe en ${file.path}');
      }
      multipartFile = MultipartFileRecreatable.fromFileSync(
        file.path,
        filename: file.name,
      );
    }

    final formData = FormData.fromMap({
      'file': multipartFile,
      if (type != null && type.isNotEmpty) 'type': type,
    });

    if (kDebugMode) {
      print('[CaptureApiClient] Enviando imagen para análisis (type: $type)');
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/analyze',
      data: formData,
    );

    if (kDebugMode) {
      print('[CaptureApiClient] Respuesta del backend: ${response.data}');
      print('[CaptureApiClient] Status code: ${response.statusCode}');
    }

    return AnalyzeResponseDto.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<AnalyzeResponseDto> analyzeBarcode(String barcode) async {
    if (kDebugMode) {
      print('[CaptureApiClient] Analizando código de barras: $barcode');
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/analyze/barcode',
      data: {'barcode': barcode},
    );

    if (kDebugMode) {
      print('[CaptureApiClient] Respuesta del backend: ${response.data}');
      print('[CaptureApiClient] Status code: ${response.statusCode}');
    }

    return AnalyzeResponseDto.fromJson(response.data ?? <String, dynamic>{});
  }
}
