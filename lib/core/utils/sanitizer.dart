class Sanitizer {
  /// Simple sanitization to remove HTML tags and trim whitespace.
  static String sanitize(String input) {
    if (input.isEmpty) return input;

    // Remove HTML tags using a simple regex
    final withoutTags = input.replaceAll(RegExp(r'<[^>]*>'), '');

    // Trim whitespace
    return withoutTags.trim();
  }

  /// Sanitizes a list of strings.
  static List<String> sanitizeList(List<String> inputs) {
    return inputs.map(sanitize).where((s) => s.isNotEmpty).toList();
  }
}
