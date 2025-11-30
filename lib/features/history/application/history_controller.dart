import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Date filter options for history
enum DateFilter {
  today,
  thisWeek,
  all,
}

/// State for history page
class HistoryState {
  const HistoryState({
    this.dateFilter = DateFilter.today,
    this.searchQuery = '',
    this.isRefreshing = false,
  });

  final DateFilter dateFilter;
  final String searchQuery;
  final bool isRefreshing;

  HistoryState copyWith({
    DateFilter? dateFilter,
    String? searchQuery,
    bool? isRefreshing,
  }) {
    return HistoryState(
      dateFilter: dateFilter ?? this.dateFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  bool get hasSearch => searchQuery.isNotEmpty;
}

/// Controller for history page state
class HistoryController extends StateNotifier<HistoryState> {
  HistoryController() : super(const HistoryState());

  void setDateFilter(DateFilter filter) {
    state = state.copyWith(dateFilter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    // Refresh logic will be handled by the UI
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isRefreshing: false);
  }
}
