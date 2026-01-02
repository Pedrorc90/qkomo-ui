import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qkomo_ui/app.dart';
import 'package:qkomo_ui/features/capture/data/hive_boxes.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/migration_service.dart';
import 'package:qkomo_ui/features/entry/domain/entities/entry.dart';
import 'package:qkomo_ui/features/feature_toggles/data/feature_toggle_hive_boxes.dart';
import 'package:qkomo_ui/features/profile/data/companion_hive_boxes.dart';
import 'package:qkomo_ui/features/menu/data/hive_boxes.dart' as menu_hive;
import 'package:qkomo_ui/features/settings/data/settings_hive_boxes.dart';
import 'package:qkomo_ui/features/sync/application/background_sync_worker.dart';
import 'package:qkomo_ui/firebase_options.dart';

/// Entry point for integration tests that allows for provider overrides.
Future<void> main({List<Override> overrides = const []}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // In testing, we might want to skip Firebase if it's not available
  // or use a fake implementation via overrides.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed (expected in some test environments): $e');
  }

  await Hive.initFlutter();
  await initializeDateFormatting('es');

  // Initialize Hive boxes
  await HiveBoxes.init();
  await menu_hive.MenuHiveBoxes.init();
  await SettingsHiveBoxes.init();
  await FeatureToggleHiveBoxes.init();
  await CompanionHiveBoxes.init();

  // Run migrations if needed
  await _runMigration();
  await _runMealMigration();

  // Initialize background sync worker
  await BackgroundSyncWorker.init();
  await BackgroundSyncWorker.registerPeriodicSync();

  runApp(
    ProviderScope(
      overrides: overrides,
      child: const SyncInitializer(),
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
  }

  @override
  Widget build(BuildContext context) {
    return const QkomoApp();
  }
}

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

Future<void> _runMealMigration() async {
  return;
}
