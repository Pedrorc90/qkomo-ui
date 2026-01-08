import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qkomo_ui/app.dart';
import 'package:qkomo_ui/core/security/hive_encryption_service.dart';
import 'package:qkomo_ui/features/feature_toggles/data/feature_toggle_hive_boxes.dart';
import 'package:qkomo_ui/features/menu/data/hive_boxes.dart' as menu_hive;
import 'package:qkomo_ui/features/profile/application/user_profile_providers.dart';
import 'package:qkomo_ui/features/profile/data/companion_hive_boxes.dart';
import 'package:qkomo_ui/features/profile/data/profile_hive_boxes.dart';
import 'package:qkomo_ui/features/settings/data/settings_hive_boxes.dart';
import 'package:qkomo_ui/features/sync/application/background_sync_worker.dart';
import 'package:qkomo_ui/features/sync/application/sync_providers.dart';
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
  await menu_hive.MenuHiveBoxes.init(encryptionKey);
  await SettingsHiveBoxes.init(encryptionKey);
  await FeatureToggleHiveBoxes.init(encryptionKey);
  await CompanionHiveBoxes.init(encryptionKey);
  await ProfileHiveBoxes.init(encryptionKey);

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

    // Initialize user profile provider (triggers automatic sync in UserProfileNotifier)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Simply reading the provider initializes the UserProfileNotifier,
      // which automatically loads cache and syncs in background
      ref.read(userProfileProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const QkomoApp();
  }
}
