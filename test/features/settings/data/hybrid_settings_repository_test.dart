import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qkomo_ui/features/settings/data/hybrid_settings_repository.dart';
import 'package:qkomo_ui/features/settings/data/local_settings_repository.dart';
import 'package:qkomo_ui/features/settings/data/remote_settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/entities/user_settings.dart';

import 'hybrid_settings_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalSettingsRepository>(),
  MockSpec<RemoteSettingsRepository>(),
  MockSpec<FirebaseAuth>(),
  MockSpec<User>(),
])
void main() {
  late HybridSettingsRepository repository;
  late MockLocalSettingsRepository mockLocalRepo;
  late MockRemoteSettingsRepository mockRemoteRepo;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    mockLocalRepo = MockLocalSettingsRepository();
    mockRemoteRepo = MockRemoteSettingsRepository();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();

    // By default, simulate authenticated user
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

    repository = HybridSettingsRepository(
      localRepo: mockLocalRepo,
      remoteRepo: mockRemoteRepo,
      firebaseAuth: mockFirebaseAuth,
      enableCloudSync: true,
    );
  });

  const tSettings = UserSettings(
    allergens: [Allergen.gluten, Allergen.lactose],
    dietaryRestrictions: [DietaryRestriction.vegan],
    languageCode: 'es',
    enableNotifications: true,
    enableDailyReminders: true,
  );

  group('HybridSettingsRepository', () {
    group('loadSettings', () {
      test('returns local settings immediately', () async {
        // Arrange
        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => true);
        when(mockRemoteRepo.fetchPreferences())
            .thenAnswer((_) async => tSettings);

        // Act
        final result = await repository.loadSettings();

        // Assert
        expect(result, tSettings);
        verify(mockLocalRepo.loadSettings()).called(1);
      });

      test('triggers background sync when cloud sync is enabled', () async {
        // Arrange
        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => true);
        when(mockRemoteRepo.fetchPreferences())
            .thenAnswer((_) async => tSettings);

        // Act
        await repository.loadSettings();

        // Small delay to allow background sync to start
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert - background sync should have been triggered
        verify(mockLocalRepo.isFirstSyncCompleted()).called(1);
        verify(mockRemoteRepo.fetchPreferences()).called(1);
      });

      test('does not sync when cloud sync is disabled', () async {
        // Arrange
        final repoWithoutSync = HybridSettingsRepository(
          localRepo: mockLocalRepo,
          remoteRepo: mockRemoteRepo,
          firebaseAuth: mockFirebaseAuth,
          enableCloudSync: false,
        );

        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);

        // Act
        await repoWithoutSync.loadSettings();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert - should not attempt sync
        verifyNever(mockLocalRepo.isFirstSyncCompleted());
        verifyNever(mockRemoteRepo.fetchPreferences());
      });

      test('does not sync when user is not authenticated', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Not authenticated
        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);

        // Act
        await repository.loadSettings();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert - should not attempt sync
        verifyNever(mockLocalRepo.isFirstSyncCompleted());
        verifyNever(mockRemoteRepo.fetchPreferences());
      });

      test('on first sync: pushes local settings to backend', () async {
        // Arrange
        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => false); // First sync
        when(mockRemoteRepo.pushPreferences(any))
            .thenAnswer((_) async => Future.value());
        when(mockLocalRepo.markFirstSyncCompleted())
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.loadSettings();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        verify(mockLocalRepo.isFirstSyncCompleted()).called(1);
        verify(mockRemoteRepo.pushPreferences(tSettings)).called(1);
        verify(mockLocalRepo.markFirstSyncCompleted()).called(1);
        verifyNever(mockRemoteRepo.fetchPreferences());
      });

      test('on subsequent sync: fetches from backend and updates local',
          () async {
        // Arrange
        const remoteSettings = UserSettings(
          allergens: [Allergen.nuts, Allergen.shellfish],
          dietaryRestrictions: [DietaryRestriction.keto],
        );

        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => true); // Not first sync
        when(mockRemoteRepo.fetchPreferences())
            .thenAnswer((_) async => remoteSettings);
        when(mockLocalRepo.saveSettings(any))
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.loadSettings();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        verify(mockLocalRepo.isFirstSyncCompleted()).called(1);
        verify(mockRemoteRepo.fetchPreferences()).called(1);

        // Should merge: remote allergens/dietary + local settings
        final captured =
            verify(mockLocalRepo.saveSettings(captureAny)).captured;
        final savedSettings = captured.first as UserSettings;

        // Remote values
        expect(savedSettings.allergens, remoteSettings.allergens);
        expect(
            savedSettings.dietaryRestrictions, remoteSettings.dietaryRestrictions);

        // Local-only values preserved
        expect(savedSettings.languageCode, tSettings.languageCode);
        expect(savedSettings.enableNotifications, tSettings.enableNotifications);
        expect(savedSettings.enableDailyReminders, tSettings.enableDailyReminders);
      });

      test('preserves local-only fields when syncing from backend', () async {
        // Arrange
        const localSettings = UserSettings(
          allergens: [Allergen.gluten],
          languageCode: 'fr', // Local-only field
          enableNotifications: false, // Local-only field
          enableDailyReminders: false, // Local-only field
        );

        const remoteSettings = UserSettings(
          allergens: [Allergen.lactose], // Different from local
        );

        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => localSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => true);
        when(mockRemoteRepo.fetchPreferences())
            .thenAnswer((_) async => remoteSettings);
        when(mockLocalRepo.saveSettings(any))
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.loadSettings();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        final captured =
            verify(mockLocalRepo.saveSettings(captureAny)).captured;
        final savedSettings = captured.first as UserSettings;

        // Remote values applied
        expect(savedSettings.allergens, [Allergen.lactose]);

        // Local-only fields preserved
        expect(savedSettings.languageCode, 'fr');
        expect(savedSettings.enableNotifications, false);
        expect(savedSettings.enableDailyReminders, false);
      });

      test('handles backend returning null (no preferences set)', () async {
        // Arrange
        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => true);
        when(mockRemoteRepo.fetchPreferences())
            .thenAnswer((_) async => null); // No preferences on backend

        // Act
        await repository.loadSettings();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        verify(mockRemoteRepo.fetchPreferences()).called(1);
        // Should not update local when backend has no preferences
        verifyNever(mockLocalRepo.saveSettings(any));
      });

      test('handles sync errors silently without throwing', () async {
        // Arrange
        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => true);
        when(mockRemoteRepo.fetchPreferences())
            .thenThrow(Exception('Network error'));

        // Act & Assert - should not throw
        final result = await repository.loadSettings();
        expect(result, tSettings);

        await Future.delayed(const Duration(milliseconds: 50));

        // Background sync failed but didn't crash
        verify(mockRemoteRepo.fetchPreferences()).called(1);
      });
    });

    group('saveSettings', () {
      test('saves to local repository immediately', () async {
        // Arrange
        when(mockLocalRepo.saveSettings(any))
            .thenAnswer((_) async => Future.value());
        when(mockRemoteRepo.pushPreferences(any))
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.saveSettings(tSettings);

        // Assert
        verify(mockLocalRepo.saveSettings(tSettings)).called(1);
      });

      test('pushes to backend in background when cloud sync enabled',
          () async {
        // Arrange
        when(mockLocalRepo.saveSettings(any))
            .thenAnswer((_) async => Future.value());
        when(mockRemoteRepo.pushPreferences(any))
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.saveSettings(tSettings);
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        verify(mockLocalRepo.saveSettings(tSettings)).called(1);
        verify(mockRemoteRepo.pushPreferences(tSettings)).called(1);
      });

      test('does not push to backend when cloud sync disabled', () async {
        // Arrange
        final repoWithoutSync = HybridSettingsRepository(
          localRepo: mockLocalRepo,
          remoteRepo: mockRemoteRepo,
          firebaseAuth: mockFirebaseAuth,
          enableCloudSync: false,
        );

        when(mockLocalRepo.saveSettings(any))
            .thenAnswer((_) async => Future.value());

        // Act
        await repoWithoutSync.saveSettings(tSettings);
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        verify(mockLocalRepo.saveSettings(tSettings)).called(1);
        verifyNever(mockRemoteRepo.pushPreferences(any));
      });

      test('does not push to backend when user is not authenticated', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Not authenticated
        when(mockLocalRepo.saveSettings(any))
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.saveSettings(tSettings);
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        verify(mockLocalRepo.saveSettings(tSettings)).called(1);
        verifyNever(mockRemoteRepo.pushPreferences(any));
      });

      test('handles backend push errors silently', () async {
        // Arrange
        when(mockLocalRepo.saveSettings(any))
            .thenAnswer((_) async => Future.value());
        when(mockRemoteRepo.pushPreferences(any))
            .thenThrow(Exception('Network error'));

        // Act & Assert - should not throw
        await repository.saveSettings(tSettings);

        verify(mockLocalRepo.saveSettings(tSettings)).called(1);

        await Future.delayed(const Duration(milliseconds: 50));

        // Background push failed but didn't crash
        verify(mockRemoteRepo.pushPreferences(tSettings)).called(1);
      });
    });

    group('clearSettings', () {
      test('clears from local repository immediately', () async {
        // Arrange
        when(mockLocalRepo.clearSettings())
            .thenAnswer((_) async => Future.value());
        when(mockRemoteRepo.deletePreferences())
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.clearSettings();

        // Assert
        verify(mockLocalRepo.clearSettings()).called(1);
      });

      test('deletes from backend in background when cloud sync enabled',
          () async {
        // Arrange
        when(mockLocalRepo.clearSettings())
            .thenAnswer((_) async => Future.value());
        when(mockRemoteRepo.deletePreferences())
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.clearSettings();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        verify(mockLocalRepo.clearSettings()).called(1);
        verify(mockRemoteRepo.deletePreferences()).called(1);
      });

      test('does not delete from backend when cloud sync disabled', () async {
        // Arrange
        final repoWithoutSync = HybridSettingsRepository(
          localRepo: mockLocalRepo,
          remoteRepo: mockRemoteRepo,
          firebaseAuth: mockFirebaseAuth,
          enableCloudSync: false,
        );

        when(mockLocalRepo.clearSettings())
            .thenAnswer((_) async => Future.value());

        // Act
        await repoWithoutSync.clearSettings();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        verify(mockLocalRepo.clearSettings()).called(1);
        verifyNever(mockRemoteRepo.deletePreferences());
      });

      test('does not delete from backend when user is not authenticated', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Not authenticated
        when(mockLocalRepo.clearSettings())
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.clearSettings();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        verify(mockLocalRepo.clearSettings()).called(1);
        verifyNever(mockRemoteRepo.deletePreferences());
      });

      test('handles backend delete errors silently', () async {
        // Arrange
        when(mockLocalRepo.clearSettings())
            .thenAnswer((_) async => Future.value());
        when(mockRemoteRepo.deletePreferences())
            .thenThrow(Exception('Network error'));

        // Act & Assert - should not throw
        await repository.clearSettings();

        verify(mockLocalRepo.clearSettings()).called(1);

        await Future.delayed(const Duration(milliseconds: 50));

        // Background delete failed but didn't crash
        verify(mockRemoteRepo.deletePreferences()).called(1);
      });
    });

    group('manualSync', () {
      test('throws when cloud sync is disabled', () async {
        // Arrange
        final repoWithoutSync = HybridSettingsRepository(
          localRepo: mockLocalRepo,
          remoteRepo: mockRemoteRepo,
          firebaseAuth: mockFirebaseAuth,
          enableCloudSync: false,
        );

        // Act & Assert
        expect(
          () => repoWithoutSync.manualSync(),
          throwsA(isA<Exception>()),
        );
      });

      test('on first sync: pushes to backend and marks as completed', () async {
        // Arrange
        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => false);
        when(mockRemoteRepo.pushPreferences(any))
            .thenAnswer((_) async => Future.value());
        when(mockLocalRepo.markFirstSyncCompleted())
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.manualSync();

        // Assert
        verify(mockLocalRepo.loadSettings()).called(1);
        verify(mockLocalRepo.isFirstSyncCompleted()).called(1);
        verify(mockRemoteRepo.pushPreferences(tSettings)).called(1);
        verify(mockLocalRepo.markFirstSyncCompleted()).called(1);
        verifyNever(mockRemoteRepo.fetchPreferences());
      });

      test('on subsequent sync: fetches from backend', () async {
        // Arrange
        const remoteSettings = UserSettings(
          allergens: [Allergen.nuts],
        );

        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => true);
        when(mockRemoteRepo.fetchPreferences())
            .thenAnswer((_) async => remoteSettings);
        when(mockLocalRepo.saveSettings(any))
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.manualSync();

        // Assert
        verify(mockLocalRepo.loadSettings()).called(1);
        verify(mockLocalRepo.isFirstSyncCompleted()).called(1);
        verify(mockRemoteRepo.fetchPreferences()).called(1);
        verify(mockLocalRepo.saveSettings(any)).called(1);
        verifyNever(mockRemoteRepo.pushPreferences(any));
      });

      test('throws errors for UI feedback (unlike background sync)', () async {
        // Arrange
        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => true);
        when(mockRemoteRepo.fetchPreferences())
            .thenThrow(Exception('Network error'));

        // Act & Assert - should throw
        expect(
          () => repository.manualSync(),
          throwsA(isA<Exception>()),
        );
      });

      test('does not update local when backend returns null', () async {
        // Arrange
        when(mockLocalRepo.loadSettings()).thenAnswer((_) async => tSettings);
        when(mockLocalRepo.isFirstSyncCompleted())
            .thenAnswer((_) async => true);
        when(mockRemoteRepo.fetchPreferences())
            .thenAnswer((_) async => null);

        // Act
        await repository.manualSync();

        // Assert
        verify(mockRemoteRepo.fetchPreferences()).called(1);
        verifyNever(mockLocalRepo.saveSettings(any));
      });
    });
  });
}
