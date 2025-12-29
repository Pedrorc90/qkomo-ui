import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/profile/domain/companion.dart';

class CompanionHiveBoxes {
  static const companions = 'companions';

  static Future<void> init() async {
    // Adapter should already be registered by build_runner generated code or manual registration if needed.
    // However, looking at companion.g.dart, it generates CompanionImplAdapter.
    // We should check if we need to manually register it or if Hive handles it.
    // Usually manual registration is safer if not using Hive.initFlutter() with auto detection which might be flaky.
    // But since companion.g.dart is part of companion.dart, we might need to import it.
    // Let's register it to be safe, similar to HiveBoxes.

    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(CompanionImplAdapter());
    }

    await Hive.openBox<Companion>(companions);
  }
}
