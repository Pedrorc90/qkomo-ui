import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery and save it to app documents directory
  /// Returns the file path or null if cancelled
  Future<String?> pickImageFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _saveImageToAppDirectory(image);
    } catch (e) {
      return null;
    }
  }

  /// Pick an image from camera and save it to app documents directory
  /// Returns the file path or null if cancelled
  Future<String?> pickImageFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _saveImageToAppDirectory(image);
    } catch (e) {
      return null;
    }
  }

  /// Save the picked image to app documents directory
  Future<String> _saveImageToAppDirectory(XFile image) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final mealsDir = path.join(appDocDir.path, 'meals');

    // Create meals directory if it doesn't exist
    final mealsDirObj = Directory(mealsDir);
    if (!await mealsDirObj.exists()) {
      await mealsDirObj.create(recursive: true);
    }

    // Generate unique filename
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final extension = path.extension(image.path);
    final filename = 'meal_$timestamp$extension';
    final savedPath = path.join(mealsDir, filename);

    // Copy file to app directory
    final sourceFile = File(image.path);
    await sourceFile.copy(savedPath);

    return savedPath;
  }

  /// Delete an image file
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore errors when deleting
    }
  }
}
