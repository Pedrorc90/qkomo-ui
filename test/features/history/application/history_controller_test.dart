import 'package:flutter_test/flutter_test.dart';
import 'package:qkomo_ui/features/history/application/history_controller.dart';

void main() {
  late HistoryController controller;

  setUp(() {
    controller = HistoryController();
  });

  tearDown(() {
    controller.dispose();
  });

  group('HistoryController - Filter Management', () {
    test('initial state has today filter', () {
      expect(controller.state.dateFilter, DateFilter.today);
    });

    test('setDateFilter updates to thisWeek', () {
      controller.setDateFilter(DateFilter.thisWeek);

      expect(controller.state.dateFilter, DateFilter.thisWeek);
    });

    test('setDateFilter updates to all', () {
      controller.setDateFilter(DateFilter.all);

      expect(controller.state.dateFilter, DateFilter.all);
    });

    test('setDateFilter updates to today', () {
      controller.setDateFilter(DateFilter.all);
      controller.setDateFilter(DateFilter.today);

      expect(controller.state.dateFilter, DateFilter.today);
    });

    test('all date filter options work correctly', () {
      // Test all enum values
      for (final filter in DateFilter.values) {
        controller.setDateFilter(filter);
        expect(controller.state.dateFilter, filter);
      }
    });
  });

  group('HistoryController - Search Functionality', () {
    test('initial state has empty search query', () {
      expect(controller.state.searchQuery, '');
      expect(controller.state.hasSearch, false);
    });

    test('setSearchQuery updates search query', () {
      controller.setSearchQuery('pizza');

      expect(controller.state.searchQuery, 'pizza');
      expect(controller.state.hasSearch, true);
    });

    test('setSearchQuery with empty string', () {
      controller.setSearchQuery('pizza');
      controller.setSearchQuery('');

      expect(controller.state.searchQuery, '');
      expect(controller.state.hasSearch, false);
    });

    test('setSearchQuery with whitespace', () {
      controller.setSearchQuery('   ');

      expect(controller.state.searchQuery, '   ');
      // hasSearch returns true even for whitespace (as per isEmpty check)
      expect(controller.state.hasSearch, true);
    });

    test('clearSearch resets search query to empty string', () {
      controller.setSearchQuery('pasta');
      expect(controller.state.searchQuery, 'pasta');

      controller.clearSearch();

      expect(controller.state.searchQuery, '');
      expect(controller.state.hasSearch, false);
    });

    test('hasSearch getter returns true when query is not empty', () {
      controller.setSearchQuery('burger');

      expect(controller.state.hasSearch, true);
    });

    test('hasSearch getter returns false when query is empty', () {
      controller.setSearchQuery('');

      expect(controller.state.hasSearch, false);
    });

    test('multiple search query updates', () {
      controller.setSearchQuery('first');
      expect(controller.state.searchQuery, 'first');

      controller.setSearchQuery('second');
      expect(controller.state.searchQuery, 'second');

      controller.setSearchQuery('third');
      expect(controller.state.searchQuery, 'third');
    });
  });

  group('HistoryController - Refresh Functionality', () {
    test('initial state is not refreshing', () {
      expect(controller.state.isRefreshing, false);
    });

    test('refresh sets isRefreshing to true then false', () async {
      expect(controller.state.isRefreshing, false);

      final refreshFuture = controller.refresh();

      // Should be refreshing immediately
      expect(controller.state.isRefreshing, true);

      await refreshFuture;

      // Should be done refreshing
      expect(controller.state.isRefreshing, false);
    });

    test('refresh completes successfully', () async {
      await expectLater(controller.refresh(), completes);
    });

    test('multiple refresh calls', () async {
      await controller.refresh();
      expect(controller.state.isRefreshing, false);

      await controller.refresh();
      expect(controller.state.isRefreshing, false);
    });
  });

  group('HistoryController - Combined State', () {
    test('filter and search can be set independently', () {
      controller.setDateFilter(DateFilter.thisWeek);
      controller.setSearchQuery('salad');

      expect(controller.state.dateFilter, DateFilter.thisWeek);
      expect(controller.state.searchQuery, 'salad');
      expect(controller.state.hasSearch, true);
    });

    test('clearing search does not affect filter', () {
      controller.setDateFilter(DateFilter.all);
      controller.setSearchQuery('chicken');
      controller.clearSearch();

      expect(controller.state.dateFilter, DateFilter.all);
      expect(controller.state.searchQuery, '');
    });

    test('changing filter does not affect search', () {
      controller.setSearchQuery('fish');
      controller.setDateFilter(DateFilter.thisWeek);

      expect(controller.state.searchQuery, 'fish');
      expect(controller.state.dateFilter, DateFilter.thisWeek);
    });

    test('refresh does not affect filter or search', () async {
      controller.setDateFilter(DateFilter.all);
      controller.setSearchQuery('soup');

      await controller.refresh();

      expect(controller.state.dateFilter, DateFilter.all);
      expect(controller.state.searchQuery, 'soup');
    });
  });
}
