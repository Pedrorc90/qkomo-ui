import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qkomo_ui/app.dart';
import 'package:qkomo_ui/core/security/hive_encryption_service.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/capture/data/hive_boxes.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/migration_service.dart';
import 'package:qkomo_ui/features/entry/domain/entities/entry.dart';
import 'package:qkomo_ui/features/feature_toggles/data/feature_toggle_hive_boxes.dart';
import 'package:qkomo_ui/features/menu/data/hive_boxes.dart' as menu_hive;
import 'package:qkomo_ui/features/profile/application/user_profile_providers.dart';
import 'package:qkomo_ui/features/profile/data/companion_hive_boxes.dart';
import 'package:qkomo_ui/features/profile/data/profile_hive_boxes.dart';
import 'package:qkomo_ui/features/settings/data/settings_hive_boxes.dart';
import 'package:qkomo_ui/features/sync/application/background_sync_worker.dart';
import 'package:qkomo_ui/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await initializeDateFormatting('es');

  // Initialize Hive encryption
  final encryptionService = HiveEncryptionService();
  final encryptionKey = await encryptionService.getEncryptionKey();

  // Initialize Hive boxes
  await HiveBoxes.init(encryptionKey);
  await menu_hive.MenuHiveBoxes.init(encryptionKey);
  await SettingsHiveBoxes.init(encryptionKey);
  await FeatureToggleHiveBoxes.init(encryptionKey);
  await CompanionHiveBoxes.init(encryptionKey);
  await ProfileHiveBoxes.init(encryptionKey);

  // Run migrations if needed
  await _runMigration();
  await _runMealMigration();

  // Initialize background sync worker
  await BackgroundSyncWorker.init();
  await BackgroundSyncWorker.registerPeriodicSync();

  runApp(
    const ProviderScope(
      child: SyncInitializer(),
    ),
  );
}

class SyncInitializer extends ConsumerStatefulWidget {
  const SyncInitializer({super.key});

  @override
  ConsumerState<SyncInitializer> createState() => _SyncInitializerState();
}

class _SyncInitializerState extends ConsumerState<SyncInitializer> {
  @override
  void initState() {
    super.initState();
    // Initialize SyncService
    ref.read(syncServiceProvider).init();

    // Sync user profile if authenticated (fire-and-forget, non-blocking)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authStateChangesProvider).valueOrNull;
      if (authState != null) {
        // User is already authenticated, sync profile in background
        ref.read(userProfileProvider.notifier).sync();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const QkomoApp();
  }
}

/// Run migration from CaptureResult to Entry
Future<void> _runMigration() async {
  final captureResultBox = Hive.box<CaptureResult>(HiveBoxes.captureResults);
  final entryBox = Hive.box<Entry>(HiveBoxes.entries);
  final localRepo = LocalEntryRepository(entryBox: entryBox);

  final migrationService = MigrationService(
    entryRepository: localRepo,
    captureResultBox: captureResultBox,
  );

  if (await migrationService.needsMigration()) {
    await migrationService.migrate();
  }
}

/// Run migration from Meal V1 to Meal V2 (with sync fields)
Future<void> _runMealMigration() async {
  // Migration no longer needed - box is always opened with V2 adapter
  // Old data will be incompatible and need manual re-entry
  return;
}
