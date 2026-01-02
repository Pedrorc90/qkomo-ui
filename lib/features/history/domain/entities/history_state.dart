import 'package:qkomo_ui/features/history/domain/entities/date_filter.dart';

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
