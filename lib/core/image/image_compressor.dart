import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Compresses images to reduce upload size and bandwidth
class ImageCompressor {
  /// Maximum width/height for compressed images (maintains aspect ratio)
  static const int maxDimension = 1024;

  /// JPEG quality for compression (0-100)
  static const int jpegQuality = 85;

  /// Compresses an image file and returns the compressed file
  /// Returns the original file if compression fails or image is already small
  static Future<XFile> compressImage(XFile imageFile) async {
    try {
      if (kDebugMode) {
        print('[ImageCompressor] Iniciando compresión de ${imageFile.name}');
      }

      // Read the original image
      final bytes = await imageFile.readAsBytes();
      final originalSize = bytes.length;

      if (kDebugMode) {
        print(
            '[ImageCompressor] Tamaño original: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB');
      }

      // Decode image
      final image = img.decodeImage(bytes);
      if (image == null) {
        if (kDebugMode) {
          print(
              '[ImageCompressor] No se pudo decodificar la imagen, usando original');
        }
        return imageFile;
      }

      // Resize if necessary (maintain aspect ratio)
      var resized = image;
      if (image.width > maxDimension || image.height > maxDimension) {
        resized = img.copyResize(
          image,
          width: image.width > image.height ? maxDimension : null,
          height: image.height > image.width ? maxDimension : null,
          interpolation: img.Interpolation.linear,
        );
        if (kDebugMode) {
          print(
              '[ImageCompressor] Redimensionada a ${resized.width}x${resized.height}');
        }
      }

      // Encode as JPEG with quality reduction
      final compressedBytes = img.encodeJpg(resized, quality: jpegQuality);
      final compressedSize = compressedBytes.length;

      if (kDebugMode) {
        print(
            '[ImageCompressor] Tamaño comprimido: ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB');
        print(
            '[ImageCompressor] Reducción: ${((1 - compressedSize / originalSize) * 100).toStringAsFixed(1)}%');
      }

      // If compressed is not significantly smaller, return original
      if (compressedSize >= originalSize * 0.9) {
        if (kDebugMode) {
          print(
              '[ImageCompressor] Compresión no significativa, usando original');
        }
        return imageFile;
      }

      // Save compressed image to temporary directory
      final tempDir = await getTemporaryDirectory();
      final compressedFile = File(
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await compressedFile.writeAsBytes(compressedBytes);

      if (kDebugMode) {
        print(
            '[ImageCompressor] Imagen comprimida guardada en ${compressedFile.path}');
      }

      return XFile(compressedFile.path, name: 'compressed_${imageFile.name}');
    } catch (e) {
      if (kDebugMode) {
        print(
            '[ImageCompressor] Error durante compresión: $e, usando original');
      }
      // Return original file if compression fails
      return imageFile;
    }
  }
}
