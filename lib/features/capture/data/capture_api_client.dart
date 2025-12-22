import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:qkomo_ui/core/image/image_compressor.dart';
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

    // Compress image to reduce upload size
    var imageToUpload = file;
    if (!kIsWeb) {
      imageToUpload = await ImageCompressor.compressImage(file);
    }

    if (kIsWeb) {
      final bytes = await imageToUpload.readAsBytes();
      multipartFile = MultipartFileRecreatable.fromBytes(
        bytes,
        filename: imageToUpload.name,
      );
    } else {
      if (!await File(imageToUpload.path).exists()) {
        throw Exception(
            'El archivo de imagen no existe en ${imageToUpload.path}');
      }
      multipartFile = MultipartFileRecreatable.fromFileSync(
        imageToUpload.path,
        filename: imageToUpload.name,
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

  /// Upload a photo to the backend and return the photo ID
  Future<String> uploadPhoto(XFile file) async {
    late MultipartFile multipartFile;

    // Compress image to reduce upload size
    var imageToUpload = file;
    if (!kIsWeb) {
      imageToUpload = await ImageCompressor.compressImage(file);
    }

    if (kIsWeb) {
      final bytes = await imageToUpload.readAsBytes();
      multipartFile = MultipartFileRecreatable.fromBytes(
        bytes,
        filename: imageToUpload.name,
      );
    } else {
      if (!await File(imageToUpload.path).exists()) {
        throw Exception(
            'El archivo de imagen no existe en ${imageToUpload.path}');
      }
      multipartFile = MultipartFileRecreatable.fromFileSync(
        imageToUpload.path,
        filename: imageToUpload.name,
      );
    }

    final formData = FormData.fromMap({
      'file': multipartFile,
    });

    if (kDebugMode) {
      print('[CaptureApiClient] Subiendo foto al backend');
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/photos',
      data: formData,
    );

    if (kDebugMode) {
      print('[CaptureApiClient] Respuesta de subida: ${response.data}');
      print('[CaptureApiClient] Status code: ${response.statusCode}');
    }

    // Backend returns 'photoId', not 'id'
    final photoId = response.data?['photoId'] as String?;
    if (photoId == null) {
      throw Exception('No se recibió el ID de la foto del backend');
    }

    if (kDebugMode) {
      print('[CaptureApiClient] Photo ID: $photoId');
    }

    return photoId;
  }

  /// Get the signed URL for a photo by its ID
  Future<String> getPhotoUrl(String photoId) async {
    if (kDebugMode) {
      print('[CaptureApiClient] Obteniendo URL de foto: $photoId');
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '/v1/photos/$photoId',
    );

    if (kDebugMode) {
      print('[CaptureApiClient] Respuesta URL: ${response.data}');
    }

    final url = response.data?['url'] as String?;
    if (url == null) {
      throw Exception('No se recibió la URL de la foto del backend');
    }

    return url;
  }
}
