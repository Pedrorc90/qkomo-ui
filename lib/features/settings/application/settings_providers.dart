import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/settings/data/settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final userSettingsProvider =
    StateNotifierProvider<UserSettingsNotifier, AsyncValue<UserSettings>>(
        (ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return UserSettingsNotifier(repository);
});

class UserSettingsNotifier extends StateNotifier<AsyncValue<UserSettings>> {
  UserSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }
  final SettingsRepository _repository;

  Future<void> _loadSettings() async {
    try {
      final settings = await _repository.loadSettings();
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    try {
      // Optimistic update
      state = AsyncValue.data(newSettings);
      await _repository.saveSettings(newSettings);
    } catch (e, st) {
      // Revert or error state? For simplicity, we just log and reload maybe
      // Or just set error.
      state = AsyncValue.error(e, st);
      // Try to reload ensuring consistency
      await _loadSettings();
    }
  }

  Future<void> toggleAllergen(Allergen allergen) async {
    final currentSettings = state.valueOrNull;
    if (currentSettings != null) {
      final currentList = currentSettings.allergens.toList();
      if (currentList.contains(allergen)) {
        currentList.remove(allergen);
      } else {
        currentList.add(allergen);
      }
      await updateSettings(currentSettings.copyWith(allergens: currentList));
    }
  }

  Future<void> toggleDietaryRestriction(DietaryRestriction restriction) async {
    final currentSettings = state.valueOrNull;
    if (currentSettings != null) {
      final currentList = currentSettings.dietaryRestrictions.toList();
      if (currentList.contains(restriction)) {
        currentList.remove(restriction);
      } else {
        currentList.add(restriction);
      }
      await updateSettings(
          currentSettings.copyWith(dietaryRestrictions: currentList));
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final currentSettings = state.valueOrNull;
    if (currentSettings != null) {
      await updateSettings(
          currentSettings.copyWith(enableNotifications: enabled));
    }
  }
}
