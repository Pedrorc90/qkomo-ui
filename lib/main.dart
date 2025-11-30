import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:qkomo_ui/app.dart';
import 'package:qkomo_ui/features/capture/data/hive_boxes.dart';
import 'package:qkomo_ui/features/menu/data/hive_boxes.dart' as menu_hive;
import 'package:qkomo_ui/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await initializeDateFormatting('es');

  // Initialize Hive boxes
  await HiveBoxes.init();
  await menu_hive.MenuHiveBoxes.init();

  runApp(
    const ProviderScope(
      child: QkomoApp(),
    ),
  );
}
