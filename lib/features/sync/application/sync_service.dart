import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:qkomo_ui/core/config/feature_flags.dart';
import 'package:qkomo_ui/features/entry/data/hybrid_entry_repository.dart';

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  success,
  error,
}

class SyncService {
  SyncService({
    required HybridEntryRepository repository,
    required Connectivity connectivity,
  })  : _repository = repository,
        _connectivity = connectivity;

  final HybridEntryRepository _repository;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  final _lastSyncTimeController = StreamController<DateTime?>.broadcast();

  SyncStatus _currentStatus = SyncStatus.idle;
  DateTime? _lastSyncTime;

  /// Stream of sync status changes
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  /// Stream of last sync time changes
  Stream<DateTime?> get lastSyncTimeStream => _lastSyncTimeController.stream;

  /// Current sync status
  SyncStatus get currentStatus => _currentStatus;

  /// Last successful sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Initialize the service
  void init() {
    if (!FeatureFlags.enableCloudSync) return;

    // Listen for connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet)) {
        // We are online, trigger sync
        _triggerAutoSync();
      }
    });

    // Initial sync check
    _triggerAutoSync();
  }

  /// Trigger a manual sync
  Future<void> sync() async {
    if (!FeatureFlags.enableCloudSync) return;
    if (_currentStatus == SyncStatus.syncing) return;

    _updateStatus(SyncStatus.syncing);

    try {
      await _repository.sync();
      _lastSyncTime = DateTime.now();
      _lastSyncTimeController.add(_lastSyncTime);
      _updateStatus(SyncStatus.success);
    } catch (e) {
      debugPrint('Sync failed: $e');
      _updateStatus(SyncStatus.error);
      // Don't rethrow for auto-sync, but UI might want to know
    } finally {
      // Reset to idle after a delay
      await Future.delayed(const Duration(seconds: 2));
      _updateStatus(SyncStatus.idle);
    }
  }

  /// Trigger automatic sync (fire and forget)
  void _triggerAutoSync() {
    sync().catchError((error) {
      debugPrint('Auto-sync failed: $error');
    });
  }

  /// Get pending sync count
  Future<int> getPendingSyncCount() async {
    return _repository.getPendingSyncCount();
  }

  void _updateStatus(SyncStatus status) {
    _currentStatus = status;
    _syncStatusController.add(status);
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncStatusController.close();
    _lastSyncTimeController.close();
  }
}
