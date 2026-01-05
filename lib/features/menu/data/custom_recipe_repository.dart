import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/custom_recipe_repository.dart';
import 'package:qkomo_ui/features/menu/domain/user_recipe.dart';
import 'package:uuid/uuid.dart';

class CustomRecipeRepositoryImpl implements CustomRecipeRepository {
  CustomRecipeRepositoryImpl({
    required Box<dynamic> recipeBox,
    required String userId,
    Uuid? uuid,
  })  : _recipeBox = recipeBox,
        _userId = userId,
        _uuid = uuid ?? const Uuid();

  final Box<dynamic> _recipeBox;
  final String _userId;
  final Uuid _uuid;

  Future<UserRecipe> create({
    required String name,
    required List<String> ingredients,
    required MealType mealType,
    String? photoPath,
  }) async {
    final recipeId = _uuid.v4();
    final recipeData = {
      'id': recipeId,
      'userId': _userId,
      'name': name,
      'ingredients': ingredients,
      'mealType': mealType.index,
      'createdAt': DateTime.now().toIso8601String(),
      'photoPath': photoPath,
    };

    await _recipeBox.put(recipeId, recipeData);

    return UserRecipe(
      id: recipeId,
      userId: _userId,
      name: name,
      ingredients: ingredients,
      mealType: mealType,
      createdAt: DateTime.now(),
      photoPath: photoPath,
    );
  }

  List<UserRecipe> allSorted() {
    final items = _recipeBox.values
        .whereType<Map<dynamic, dynamic>>()
        .where((recipe) => recipe['userId'] == _userId)
        .map(_mapToRecipe)
        .toList();
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  List<UserRecipe> byMealType(MealType mealType) {
    return _recipeBox.values
        .whereType<Map<dynamic, dynamic>>()
        .where((recipe) =>
            recipe['userId'] == _userId && recipe['mealType'] == mealType.index)
        .map(_mapToRecipe)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  UserRecipe? getById(String id) {
    final data = _recipeBox.get(id);
    if (data is Map<dynamic, dynamic>) {
      return _mapToRecipe(data);
    }
    return null;
  }

  Future<void> update(String id, UserRecipe recipe) async {
    final existing = _recipeBox.get(id);
    if (existing == null) return;

    final recipeData = {
      'id': recipe.id,
      'userId': recipe.userId,
      'name': recipe.name,
      'ingredients': recipe.ingredients,
      'mealType': recipe.mealType.index,
      'createdAt': recipe.createdAt.toIso8601String(),
      'photoPath': recipe.photoPath,
    };

    await _recipeBox.put(id, recipeData);
  }

  Future<void> delete(String id) {
    return _recipeBox.delete(id);
  }

  UserRecipe _mapToRecipe(Map<dynamic, dynamic> data) {
    return UserRecipe(
      id: data['id'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      ingredients: (data['ingredients'] as List?)?.cast<String>() ?? [],
      mealType: MealType.values[data['mealType'] as int? ?? 0],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
      photoPath: data['photoPath'] as String?,
    );
  }
}
