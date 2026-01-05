/// Returns the Monday of the week for the given date (normalized to 00:00).
DateTime mondayOfWeek(DateTime date) {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  final daysSinceMonday = normalizedDate.weekday - DateTime.monday;
  return normalizedDate.subtract(Duration(days: daysSinceMonday));
}

/// Formats date as YYYY-MM-DD.
String ymd(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

/// Parses YYYY-MM-DD string to DateTime.
DateTime parseYmd(String dateStr) {
  final parts = dateStr.split('-');
  if (parts.length != 3) {
    throw FormatException('Invalid date format: $dateStr. Expected YYYY-MM-DD');
  }
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final day = int.parse(parts[2]);
  return DateTime(year, month, day);
}
