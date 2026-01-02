/// Repository interface for tracking deleted preset recipes
///
/// Manages which preset recipes the user has dismissed/hidden.
/// Allows users to restore previously deleted presets.
abstract class DeletedPresetRecipesRepository {
  /// Mark a preset recipe as deleted (hidden)
  Future<void> markAsDeleted(String recipeName);

  /// Restore a previously deleted recipe
  Future<void> restore(String recipeName);

  /// Check if a recipe name is marked as deleted
  bool isDeleted(String recipeName);

  /// Get all deleted recipe names
  List<String> getDeletedRecipeNames();

  /// Clear all deleted markers (restore all)
  Future<void> clear();
}
