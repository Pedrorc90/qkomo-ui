import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionOutcome {
  const PermissionOutcome({required this.granted, this.needsSettings = false});

  final bool granted;
  final bool needsSettings;
}

class CapturePermissions {
  Future<PermissionOutcome> ensureCameraAccess() async {
    if (kIsWeb) return const PermissionOutcome(granted: true);
    final status = await Permission.camera.request();
    if (status.isGranted || status.isLimited) {
      return const PermissionOutcome(granted: true);
    }
    return PermissionOutcome(
      granted: false,
      needsSettings: status.isPermanentlyDenied || status.isRestricted,
    );
  }

  Future<PermissionOutcome> ensureGalleryAccess() async {
    if (kIsWeb) return const PermissionOutcome(granted: true);

    // Para Android 13+ (API 33+), usar Permission.photos
    // Para versiones anteriores, usar Permission.storage
    Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else if (Platform.isAndroid) {
      // En Android 13+, photos es el permiso correcto para acceder a imágenes
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }

    final status = await permission.request();
    if (status.isGranted || status.isLimited) {
      return const PermissionOutcome(granted: true);
    }
    return PermissionOutcome(
      granted: false,
      needsSettings: status.isPermanentlyDenied || status.isRestricted,
    );
  }

  Future<void> openSettings() {
    return openAppSettings();
  }
}
