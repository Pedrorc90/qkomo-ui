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
    final permission = Platform.isIOS ? Permission.photos : Permission.storage;
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
