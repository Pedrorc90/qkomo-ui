import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entities/entry.dart';

/// Service to migrate existing CaptureResult data to Entry model
class MigrationService {
  MigrationService({
    required LocalEntryRepository entryRepository,
    required Box<CaptureResult> captureResultBox,
  })  : _entryRepository = entryRepository,
        _captureResultBox = captureResultBox;

  final LocalEntryRepository _entryRepository;
  final Box<CaptureResult> _captureResultBox;

  static const String _migrationVersionKey = 'migration_version';
  static const int _currentMigrationVersion = 1;

  /// Check if migration is needed
  Future<bool> needsMigration() async {
    final box = await Hive.openBox<int>('migration_metadata');
    final version = box.get(_migrationVersionKey, defaultValue: 0) ?? 0;
    return version < _currentMigrationVersion;
  }

  /// Run migration from CaptureResult to Entry
  Future<void> migrate() async {
    final box = await Hive.openBox<int>('migration_metadata');
    final version = box.get(_migrationVersionKey, defaultValue: 0) ?? 0;

    if (version >= _currentMigrationVersion) {
      // Already migrated
      return;
    }

    // Migrate all CaptureResult entries to Entry model
    final captureResults = _captureResultBox.values.toList();

    for (final result in captureResults) {
      // Check if already migrated
      final existingEntry = _entryRepository.getEntryById(result.jobId);
      if (existingEntry != null) {
        continue;
      }

      // Create new Entry from CaptureResult
      final entry = Entry(
        id: result.jobId,
        result: result,
        lastModifiedAt: result.savedAt,
      );

      await _entryRepository.saveEntry(entry);
    }

    // Update migration version
    await box.put(_migrationVersionKey, _currentMigrationVersion);
  }

  /// Get migration progress (for UI feedback)
  Future<MigrationProgress> getProgress() async {
    final totalResults = _captureResultBox.length;
    final migratedCount = _captureResultBox.values
        .where((result) => _entryRepository.getEntryById(result.jobId) != null)
        .length;

    return MigrationProgress(
      total: totalResults,
      migrated: migratedCount,
      isComplete: migratedCount >= totalResults,
    );
  }
}

/// Migration progress data
class MigrationProgress {
  MigrationProgress({
    required this.total,
    required this.migrated,
    required this.isComplete,
  });

  final int total;
  final int migrated;
  final bool isComplete;

  double get percentage => total > 0 ? migrated / total : 1.0;
}
