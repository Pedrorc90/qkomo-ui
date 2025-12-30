import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/config/env.dart';
import 'package:qkomo_ui/core/http/dio_provider.dart';
import 'package:qkomo_ui/features/settings/data/hybrid_settings_repository.dart';
import 'package:qkomo_ui/features/settings/data/local_settings_repository.dart';
import 'package:qkomo_ui/features/settings/data/remote_settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

/// Provider for local settings repository (Hive storage)
final localSettingsRepositoryProvider = Provider<LocalSettingsRepository>((ref) {
  return LocalSettingsRepository();
});

/// Provider for remote settings repository (API client)
final remoteSettingsRepositoryProvider = Provider<RemoteSettingsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RemoteSettingsRepository(dio: dio);
});

/// Provider for hybrid settings repository (combines local + remote)
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final localRepo = ref.watch(localSettingsRepositoryProvider);
  final remoteRepo = ref.watch(remoteSettingsRepositoryProvider);

  return HybridSettingsRepository(
    localRepo: localRepo,
    remoteRepo: remoteRepo,
    enableCloudSync: EnvConfig.enableCloudSync,
  );
});

final userSettingsProvider =
    StateNotifierProvider<UserSettingsNotifier, AsyncValue<UserSettings>>((ref) {
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
      await updateSettings(currentSettings.copyWith(dietaryRestrictions: currentList));
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final currentSettings = state.valueOrNull;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(enableNotifications: enabled));
    }
  }

  Future<void> setThemeType(AppThemeType themeType) async {
    final currentSettings = state.valueOrNull;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(themeType: themeType));
    }
  }
}
