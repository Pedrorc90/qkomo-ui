import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';

/// Date grouping categories for history
enum DateGroup {
  today,
  yesterday,
  thisWeek,
  older,
}

/// Helper class for date grouping and formatting
class DateGroupingHelper {
  /// Get the date group for a given date
  static DateGroup getDateGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return DateGroup.today;
    } else if (difference == 1) {
      return DateGroup.yesterday;
    } else if (difference < 7) {
      return DateGroup.thisWeek;
    } else {
      return DateGroup.older;
    }
  }

  /// Get Spanish label for date group
  static String getDateGroupLabel(DateGroup group, {DateTime? date}) {
    switch (group) {
      case DateGroup.today:
        return 'Hoy';
      case DateGroup.yesterday:
        return 'Ayer';
      case DateGroup.thisWeek:
        return 'Esta semana';
      case DateGroup.older:
        if (date != null) {
          return formatDate(date);
        }
        return 'Anteriores';
    }
  }

  /// Format date in Spanish format: "Lunes, 27 de noviembre"
  static String formatDate(DateTime date) {
    final dayOfWeek = _getDayOfWeekSpanish(date.weekday);
    final day = date.day;
    final month = _getMonthSpanish(date.month);
    return '$dayOfWeek, $day de $month';
  }

  /// Get day of week in Spanish
  static String _getDayOfWeekSpanish(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Lunes';
      case DateTime.tuesday:
        return 'Martes';
      case DateTime.wednesday:
        return 'Miércoles';
      case DateTime.thursday:
        return 'Jueves';
      case DateTime.friday:
        return 'Viernes';
      case DateTime.saturday:
        return 'Sábado';
      case DateTime.sunday:
        return 'Domingo';
      default:
        return '';
    }
  }

  /// Get month in Spanish
  static String _getMonthSpanish(int month) {
    switch (month) {
      case 1:
        return 'enero';
      case 2:
        return 'febrero';
      case 3:
        return 'marzo';
      case 4:
        return 'abril';
      case 5:
        return 'mayo';
      case 6:
        return 'junio';
      case 7:
        return 'julio';
      case 8:
        return 'agosto';
      case 9:
        return 'septiembre';
      case 10:
        return 'octubre';
      case 11:
        return 'noviembre';
      case 12:
        return 'diciembre';
      default:
        return '';
    }
  }

  /// Group results by date
  static Map<DateGroup, List<CaptureResult>> groupResultsByDate(
    List<CaptureResult> results,
  ) {
    final grouped = <DateGroup, List<CaptureResult>>{
      DateGroup.today: [],
      DateGroup.yesterday: [],
      DateGroup.thisWeek: [],
      DateGroup.older: [],
    };

    for (final result in results) {
      final group = getDateGroup(result.savedAt);
      grouped[group]!.add(result);
    }

    return grouped;
  }

  /// Group entries by date
  static Map<DateGroup, List<Entry>> groupEntriesByDate(
    List<Entry> entries,
  ) {
    final grouped = <DateGroup, List<Entry>>{
      DateGroup.today: [],
      DateGroup.yesterday: [],
      DateGroup.thisWeek: [],
      DateGroup.older: [],
    };

    for (final entry in entries) {
      final group = getDateGroup(entry.result.savedAt);
      grouped[group]!.add(entry);
    }

    return grouped;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    return date.isAfter(startOfWeekDate.subtract(const Duration(days: 1)));
  }

  /// Check if date is this month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Get start of today
  static DateTime getStartOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get start of this week (Monday)
  static DateTime getStartOfThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  /// Get start of this month
  static DateTime getStartOfThisMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }
}
