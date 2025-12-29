import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/profile/data/companion_hive_boxes.dart';
import 'package:qkomo_ui/features/profile/domain/companion.dart';

class CompanionLocalDataSource {
  Box<Companion> get _box => Hive.box<Companion>(CompanionHiveBoxes.companions);

  List<Companion> getCompanions() {
    return _box.values.toList();
  }

  Future<void> saveCompanions(List<Companion> companions) async {
    await _box.clear();
    await _box.addAll(companions);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
