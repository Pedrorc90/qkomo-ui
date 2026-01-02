import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:qkomo_ui/core/config/feature_flags.dart';
import 'package:qkomo_ui/features/sync/domain/interfaces/syncable_repository.dart';

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  success,
  error,
}

class SyncService {
  SyncService({
    required List<SyncableRepository> repositories,
    required Connectivity connectivity,
  })  : _repositories = repositories,
        _connectivity = connectivity;

  final List<SyncableRepository> _repositories;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  final _lastSyncTimeController = StreamController<DateTime?>.broadcast();

  SyncStatus _currentStatus = SyncStatus.idle;
  DateTime? _lastSyncTime;

  int _continuousFailures = 0;
  Timer? _retryTimer;

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
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
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

    // specific status for UI
    _updateStatus(SyncStatus.syncing);

    try {
      // Sync all repositories sequentially
      for (final repo in _repositories) {
        debugPrint('Syncing ${repo.repositoryName}...');
        await repo.sync();
      }

      _lastSyncTime = DateTime.now();
      _lastSyncTimeController.add(_lastSyncTime);
      _updateStatus(SyncStatus.success);

      // Reset failure count on success
      _continuousFailures = 0;
      _retryTimer?.cancel();
    } catch (e) {
      debugPrint('Sync failed: $e');
      _updateStatus(SyncStatus.error);

      // Schedule retry with backoff
      _continuousFailures++;
      _scheduleRetry();
    } finally {
      // Reset to idle after a delay
      await Future.delayed(const Duration(seconds: 2));
      // Only set to idle if we aren't already syncing again (rare race condition)
      if (_currentStatus != SyncStatus.syncing) {
        _updateStatus(SyncStatus.idle);
      }
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();

    // Exponential backoff: 30s, 60s, 120s... max 1 hour
    final delaySeconds =
        min(30 * pow(2, _continuousFailures - 1).toInt(), 3600);
    debugPrint(
        'Scheduling sync retry in $delaySeconds seconds (attempt $_continuousFailures)');

    _retryTimer = Timer(Duration(seconds: delaySeconds), () {
      debugPrint('Retrying sync...');
      _triggerAutoSync();
    });
  }

  /// Trigger automatic sync (fire and forget)
  void _triggerAutoSync() {
    sync().catchError((error) {
      debugPrint('Auto-sync failed: $error');
    });
  }

  /// Get pending sync count across all repositories
  Future<int> getPendingSyncCount() async {
    int total = 0;
    for (final repo in _repositories) {
      total += await repo.getPendingSyncCount();
    }
    return total;
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
    _retryTimer?.cancel();
  }
}
