import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qkomo_ui/features/settings/data/remote_settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

import 'remote_settings_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late RemoteSettingsRepository repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = RemoteSettingsRepository(dio: mockDio);
  });

  group('RemoteSettingsRepository', () {
    group('fetchPreferences', () {
      test('returns UserSettings when backend returns 200', () async {
        // Arrange
        final responseData = {
          'allergens': 'gluten,lactose,nuts',
          'dietary_preferences': 'vegan,keto',
          'created_at': '2025-01-15T10:00:00.000Z',
          'updated_at': '2025-01-15T12:00:00.000Z',
        };

        when(mockDio.get<Map<String, dynamic>>('/v1/preferences'))
            .thenAnswer((_) async => Response(
                  data: responseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/v1/preferences'),
                ));

        // Act
        final result = await repository.fetchPreferences();

        // Assert
        expect(result, isNotNull);
        expect(result!.allergens, [
          Allergen.gluten,
          Allergen.lactose,
          Allergen.nuts,
        ]);
        expect(result.dietaryRestrictions, [
          DietaryRestriction.vegan,
          DietaryRestriction.keto,
        ]);
        verify(mockDio.get<Map<String, dynamic>>('/v1/preferences')).called(1);
      });

      test('returns null when backend returns 404', () async {
        // Arrange
        when(mockDio.get<Map<String, dynamic>>('/v1/preferences')).thenThrow(
          DioException(
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/v1/preferences'),
            ),
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act
        final result = await repository.fetchPreferences();

        // Assert
        expect(result, isNull);
        verify(mockDio.get<Map<String, dynamic>>('/v1/preferences')).called(1);
      });

      test('returns null when backend returns empty response', () async {
        // Arrange
        when(mockDio.get<Map<String, dynamic>>('/v1/preferences'))
            .thenAnswer((_) async => Response(
                  data: null,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/v1/preferences'),
                ));

        // Act
        final result = await repository.fetchPreferences();

        // Assert
        expect(result, isNull);
      });

      test('returns UserSettings with empty lists when backend has empty strings',
          () async {
        // Arrange
        final responseData = {
          'allergens': '',
          'dietary_preferences': '',
        };

        when(mockDio.get<Map<String, dynamic>>('/v1/preferences'))
            .thenAnswer((_) async => Response(
                  data: responseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/v1/preferences'),
                ));

        // Act
        final result = await repository.fetchPreferences();

        // Assert
        expect(result, isNotNull);
        expect(result!.allergens, isEmpty);
        expect(result.dietaryRestrictions, isEmpty);
      });

      test('filters out invalid allergen values from backend', () async {
        // Arrange
        final responseData = {
          'allergens': 'gluten,invalid,lactose,unknown',
          'dietary_preferences': '',
        };

        when(mockDio.get<Map<String, dynamic>>('/v1/preferences'))
            .thenAnswer((_) async => Response(
                  data: responseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/v1/preferences'),
                ));

        // Act
        final result = await repository.fetchPreferences();

        // Assert
        expect(result, isNotNull);
        expect(result!.allergens, [Allergen.gluten, Allergen.lactose]);
      });

      test('throws DioException on network error', () async {
        // Arrange
        when(mockDio.get<Map<String, dynamic>>('/v1/preferences')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () => repository.fetchPreferences(),
          throwsA(isA<DioException>()),
        );
      });

      test('throws DioException on 500 server error', () async {
        // Arrange
        when(mockDio.get<Map<String, dynamic>>('/v1/preferences')).thenThrow(
          DioException(
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: '/v1/preferences'),
            ),
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act & Assert
        expect(
          () => repository.fetchPreferences(),
          throwsA(isA<DioException>()),
        );
      });

      test('throws DioException on 401 unauthorized', () async {
        // Arrange
        when(mockDio.get<Map<String, dynamic>>('/v1/preferences')).thenThrow(
          DioException(
            response: Response(
              statusCode: 401,
              requestOptions: RequestOptions(path: '/v1/preferences'),
            ),
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act & Assert
        expect(
          () => repository.fetchPreferences(),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('pushPreferences', () {
      test('sends correct payload to backend on PUT', () async {
        // Arrange
        const settings = UserSettings(
          allergens: [Allergen.gluten, Allergen.lactose],
          dietaryRestrictions: [DietaryRestriction.vegan, DietaryRestriction.keto],
        );

        when(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/v1/preferences'),
                ));

        // Act
        await repository.pushPreferences(settings);

        // Assert
        final captured = verify(
          mockDio.put<void>('/v1/preferences', data: captureAnyNamed('data')),
        ).captured;

        expect(captured.length, 1);
        final payload = captured[0] as Map<String, dynamic>;
        expect(payload['allergens'], 'gluten,lactose');
        expect(payload['dietary_preferences'], 'vegan,keto');
      });

      test('sends null for empty allergens list', () async {
        // Arrange
        const settings = UserSettings(allergens: []);

        when(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/v1/preferences'),
                ));

        // Act
        await repository.pushPreferences(settings);

        // Assert
        final captured = verify(
          mockDio.put<void>('/v1/preferences', data: captureAnyNamed('data')),
        ).captured;

        final payload = captured[0] as Map<String, dynamic>;
        expect(payload['allergens'], isNull);
      });

      test('does not include local-only fields in payload', () async {
        // Arrange
        const settings = UserSettings(
          languageCode: 'en',
          enableNotifications: false,
          enableDailyReminders: false,
        );

        when(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/v1/preferences'),
                ));

        // Act
        await repository.pushPreferences(settings);

        // Assert
        final captured = verify(
          mockDio.put<void>('/v1/preferences', data: captureAnyNamed('data')),
        ).captured;

        final payload = captured[0] as Map<String, dynamic>;
        expect(payload.containsKey('languageCode'), false);
        expect(payload.containsKey('enableNotifications'), false);
        expect(payload.containsKey('enableDailyReminders'), false);
      });

      test('completes successfully on 200', () async {
        // Arrange
        const settings = UserSettings(allergens: [Allergen.gluten]);

        when(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/v1/preferences'),
                ));

        // Act & Assert - should not throw
        await repository.pushPreferences(settings);

        verify(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .called(1);
      });

      test('throws ValidationException on 400 with message', () async {
        // Arrange
        const settings = UserSettings(allergens: [Allergen.gluten]);

        when(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .thenThrow(
          DioException(
            response: Response(
              statusCode: 400,
              data: {'message': 'Alérgeno inválido'},
              requestOptions: RequestOptions(path: '/v1/preferences'),
            ),
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act & Assert
        expect(
          () => repository.pushPreferences(settings),
          throwsA(isA<ValidationException>().having(
            (e) => e.message,
            'message',
            'Alérgeno inválido',
          )),
        );
      });

      test('throws ValidationException on 400 without message', () async {
        // Arrange
        const settings = UserSettings(allergens: [Allergen.gluten]);

        when(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .thenThrow(
          DioException(
            response: Response(
              statusCode: 400,
              data: {},
              requestOptions: RequestOptions(path: '/v1/preferences'),
            ),
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act & Assert
        expect(
          () => repository.pushPreferences(settings),
          throwsA(isA<ValidationException>().having(
            (e) => e.message,
            'message',
            'Error de validación al guardar preferencias',
          )),
        );
      });

      test('throws DioException on network error', () async {
        // Arrange
        const settings = UserSettings(allergens: [Allergen.gluten]);

        when(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () => repository.pushPreferences(settings),
          throwsA(isA<DioException>()),
        );
      });

      test('throws DioException on 500 server error', () async {
        // Arrange
        const settings = UserSettings(allergens: [Allergen.gluten]);

        when(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .thenThrow(
          DioException(
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: '/v1/preferences'),
            ),
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act & Assert
        expect(
          () => repository.pushPreferences(settings),
          throwsA(isA<DioException>()),
        );
      });

      test('preserves camelCase in dietary restriction names', () async {
        // Arrange
        const settings = UserSettings(
          dietaryRestrictions: [
            DietaryRestriction.lowCarb,
            DietaryRestriction.glutenFree,
          ],
        );

        when(mockDio.put<void>('/v1/preferences', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/v1/preferences'),
                ));

        // Act
        await repository.pushPreferences(settings);

        // Assert
        final captured = verify(
          mockDio.put<void>('/v1/preferences', data: captureAnyNamed('data')),
        ).captured;

        final payload = captured[0] as Map<String, dynamic>;
        expect(payload['dietary_preferences'], 'lowCarb,glutenFree');
      });
    });

    group('deletePreferences', () {
      test('completes successfully on 200', () async {
        // Arrange
        when(mockDio.delete<void>('/v1/preferences')).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/v1/preferences'),
          ),
        );

        // Act & Assert - should not throw
        await repository.deletePreferences();

        verify(mockDio.delete<void>('/v1/preferences')).called(1);
      });

      test('treats 404 as success (already deleted)', () async {
        // Arrange
        when(mockDio.delete<void>('/v1/preferences')).thenThrow(
          DioException(
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/v1/preferences'),
            ),
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act & Assert - should not throw
        await repository.deletePreferences();

        verify(mockDio.delete<void>('/v1/preferences')).called(1);
      });

      test('throws DioException on network error', () async {
        // Arrange
        when(mockDio.delete<void>('/v1/preferences')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () => repository.deletePreferences(),
          throwsA(isA<DioException>()),
        );
      });

      test('throws DioException on 500 server error', () async {
        // Arrange
        when(mockDio.delete<void>('/v1/preferences')).thenThrow(
          DioException(
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: '/v1/preferences'),
            ),
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act & Assert
        expect(
          () => repository.deletePreferences(),
          throwsA(isA<DioException>()),
        );
      });

      test('throws DioException on 401 unauthorized', () async {
        // Arrange
        when(mockDio.delete<void>('/v1/preferences')).thenThrow(
          DioException(
            response: Response(
              statusCode: 401,
              requestOptions: RequestOptions(path: '/v1/preferences'),
            ),
            requestOptions: RequestOptions(path: '/v1/preferences'),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act & Assert
        expect(
          () => repository.deletePreferences(),
          throwsA(isA<DioException>()),
        );
      });
    });
  });
}
