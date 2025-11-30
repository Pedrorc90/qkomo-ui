import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'models/analyze_response_dto.dart';

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
      multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: file.name,
      );
    } else {
      if (!await File(file.path).exists()) {
        throw Exception('El archivo de imagen no existe en ${file.path}');
      }
      multipartFile = await MultipartFile.fromFile(file.path);
    }

    final formData = FormData.fromMap({
      'file': multipartFile,
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
