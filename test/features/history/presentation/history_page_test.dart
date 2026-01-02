import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/features/entry/domain/entities/entry.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/history/application/history_controller.dart';
import 'package:qkomo_ui/features/history/application/history_providers.dart';
import 'package:qkomo_ui/features/history/domain/entities/date_filter.dart';
import 'package:qkomo_ui/features/history/domain/entities/date_group.dart';
import 'package:qkomo_ui/features/history/domain/entities/history_state.dart';
import 'package:qkomo_ui/features/history/presentation/history_page.dart';

// Fakes
class FakeHistoryController extends StateNotifier<HistoryState> implements HistoryController {
  FakeHistoryController(super.state);

  @override
  void setDateFilter(DateFilter filter) {
    state = state.copyWith(dateFilter: filter);
  }

  @override
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  @override
  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  @override
  Future<void> refresh() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
    ingredients: ['Apple', 'Banana'],
    allergens: [],
  ),
);

final yesterdayEntry = Entry(
  id: '2',
  lastModifiedAt: DateTime.now().subtract(const Duration(days: 1)),
  syncStatus: SyncStatus.synced,
  result: CaptureResult(
    jobId: 'job2',
    savedAt: DateTime.now().subtract(const Duration(days: 1)),
    title: 'Yesterday Salad',
    ingredients: ['Lettuce', 'Tomato'],
    allergens: [],
  ),
);

void main() {
  late FakeHistoryController mockController;

  setUp(() async {
    await initializeDateFormatting('es');
    mockController = FakeHistoryController(const HistoryState());
  });

  Widget buildTestWidget({
    Map<DateGroup, List<Entry>>? groupedEntries,
    AsyncValue<List<Entry>>? entriesAsync,
    Map<DateFilter, int>? filterCounts,
  }) {
    return ProviderScope(
      overrides: [
        historyControllerProvider.overrideWith((ref) => mockController),
        if (groupedEntries != null) groupedEntriesProvider.overrideWithValue(groupedEntries),
        if (entriesAsync != null)
          entriesStreamProvider.overrideWith((ref) => Stream.value(entriesAsync.value ?? [])),
        if (filterCounts != null) filterCountsProvider.overrideWithValue(filterCounts),
      ],
      child: const MaterialApp(
        home: HistoryPage(),
      ),
    );
  }

  testWidgets('HistoryPage renders empty state when no entries', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      groupedEntries: {},
      entriesAsync: const AsyncValue.data([]),
      filterCounts: {
        DateFilter.today: 0,
        DateFilter.thisWeek: 0,
        DateFilter.all: 0,
      },
    ));

    // Verify empty state message for 'today' (default filter)
    expect(find.text('Aún no has registrado comidas hoy.\n¡Empieza capturando una foto!'),
        findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
  });

  testWidgets('HistoryPage renders grouped entries correctly', (tester) async {
    final grouped = {
      DateGroup.today: [dummyEntry],
      DateGroup.yesterday: [yesterdayEntry],
    };

    await tester.pumpWidget(buildTestWidget(
      groupedEntries: grouped,
      entriesAsync: AsyncValue.data([dummyEntry, yesterdayEntry]),
      filterCounts: {
        DateFilter.today: 1,
        DateFilter.thisWeek: 2,
        DateFilter.all: 2,
      },
    ));

    // Verify headers (Hoy appears in FilterTabs and GroupHeader)
    expect(find.text('Hoy'), findsAtLeastNWidgets(1));
    expect(find.text('Ayer'), findsOneWidget);

    // Verify entry titles
    expect(find.text('Test Meal'), findsOneWidget);
    expect(find.text('Yesterday Salad'), findsOneWidget);
  });

  testWidgets('DateFilterTabs updates controller when a tab is tapped', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      groupedEntries: {},
      entriesAsync: const AsyncValue.data([]),
      filterCounts: {
        DateFilter.today: 0,
        DateFilter.thisWeek: 0,
        DateFilter.all: 0,
      },
    ));

    // Initially today is selected (default)
    expect(mockController.state.dateFilter, DateFilter.today);

    // Tap 'Esta semana'
    await tester.tap(find.text('Esta semana'));
    await tester.pumpAndSettle();

    // Verify filter changed
    expect(mockController.state.dateFilter, DateFilter.thisWeek);

    // Tap 'Todo'
    await tester.tap(find.text('Todo'));
    await tester.pumpAndSettle();

    // Verify filter changed
    expect(mockController.state.dateFilter, DateFilter.all);
  });

  testWidgets('HistorySearchBar updates search query in controller', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      groupedEntries: {},
      entriesAsync: const AsyncValue.data([]),
      filterCounts: {
        DateFilter.today: 0,
        DateFilter.thisWeek: 0,
        DateFilter.all: 0,
      },
    ));

    // Tap search icon to expand (assuming it needs expanding)
    final searchIcon = find.byIcon(Icons.search);
    if (searchIcon.evaluate().isNotEmpty) {
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();
    }

    // Entering text in search bar
    final searchTextField = find.byType(TextField);
    expect(searchTextField, findsOneWidget);

    await tester.enterText(searchTextField, 'Apple');
    await tester.pumpAndSettle();

    // Verify search query updated
    expect(mockController.state.searchQuery, 'Apple');
  });

  testWidgets('Empty state changes when searching', (tester) async {
    // Set state to searching
    mockController.setSearchQuery('Non-existent');

    await tester.pumpWidget(buildTestWidget(
      groupedEntries: {},
      entriesAsync: const AsyncValue.data([]),
      filterCounts: {
        DateFilter.today: 0,
        DateFilter.thisWeek: 0,
        DateFilter.all: 0,
      },
    ));

    // Verify search-specific empty state
    expect(find.text('No se encontraron resultados para "Non-existent"'), findsOneWidget);
    expect(find.byIcon(Icons.search_off), findsOneWidget);
  });
}
