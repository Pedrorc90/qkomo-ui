class AiWeeklyMenuDisabledException implements Exception {
  AiWeeklyMenuDisabledException(
      [this.message = 'AI weekly menu is disabled on backend']);

  final String message;

  @override
  String toString() => 'AiWeeklyMenuDisabledException: $message';
}
