import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/history/domain/entities/date_filter.dart';
import 'package:qkomo_ui/features/history/domain/entities/history_state.dart';

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
