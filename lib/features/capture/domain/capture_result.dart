class CaptureResult {
  CaptureResult({
    required this.jobId,
    required this.savedAt,
    this.ingredients = const [],
    this.allergens = const [],
    this.notes,
    this.title,
  });

  final String jobId;
  final DateTime savedAt;
  final List<String> ingredients;
  final List<String> allergens;
  final String? notes;
  final String? title;
}
