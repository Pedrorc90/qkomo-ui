import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/deleted_preset_recipes_repository.dart';

class DeletedPresetRecipesRepositoryImpl
    implements DeletedPresetRecipesRepository {
  DeletedPresetRecipesRepositoryImpl({required Box<String> box}) : _box = box;

  final Box<String> _box;

  Future<void> markAsDeleted(String recipeName) async {
    await _box.put(recipeName, recipeName);
  }

  Future<void> restore(String recipeName) async {
    await _box.delete(recipeName);
  }

  bool isDeleted(String recipeName) {
    return _box.containsKey(recipeName);
  }

  List<String> getDeletedRecipeNames() {
    return _box.values.toList();
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
