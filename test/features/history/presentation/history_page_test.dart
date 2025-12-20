import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/history/application/history_controller.dart';
import 'package:qkomo_ui/features/history/application/history_providers.dart';
import 'package:qkomo_ui/features/history/presentation/history_page.dart';
import 'package:qkomo_ui/features/history/utils/date_grouping_helper.dart';

// Fakes
class FakeHistoryController extends StateNotifier<HistoryState> implements HistoryController {
  FakeHistoryController(super.state);

  @override
  void setDateFilter(DateFilter filter) {}
  @override
  void setSearchQuery(String query) {}
  @override
  void clearSearch() {}
  @override
  Future<void> refresh() async {}
}

// Dummy data
final dummyEntry = Entry(
  id: '1',
  lastModifiedAt: DateTime.now(),
  syncStatus: SyncStatus.synced,
  result: CaptureResult(
    jobId: 'job1',
    savedAt: DateTime.now(),
    title: 'Test Meal',
    ingredients: [],
    allergens: [],
  ),
);

void main() {
  testWidgets('HistoryPage renders empty state when no entries', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyControllerProvider
              .overrideWith((ref) => FakeHistoryController(const HistoryState())),
          groupedEntriesProvider.overrideWithValue({}),
        ],
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );

    // Verify empty state message for 'today' (default filter)
    expect(find.text('Aún no has registrado comidas hoy.\n¡Empieza capturando una foto!'),
        findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
  });

  testWidgets('HistoryPage renders grouped entries correctly', (tester) async {
    final grouped = {
      DateGroup.today: [dummyEntry],
    };

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyControllerProvider
              .overrideWith((ref) => FakeHistoryController(const HistoryState())),
          groupedEntriesProvider.overrideWithValue(grouped),
        ],
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );

    // Verify header
    expect(find.text('Hoy'), findsOneWidget);

    // Verify entry title
    expect(find.text('Test Meal'), findsOneWidget);
  });
}
