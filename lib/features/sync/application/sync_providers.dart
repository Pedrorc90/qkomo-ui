import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/sync/application/sync_service.dart';

/// Provider for Connectivity instance
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// Provider for SyncService
///
/// Currently provides an empty repositories list.
/// TODO: Add syncable repositories when implementing cloud sync
final syncServiceProvider = Provider<SyncService>((ref) {
  final connectivity = ref.watch(connectivityProvider);

  return SyncService(
    repositories: [], // TODO: Add syncable repositories
    connectivity: connectivity,
  );
});
