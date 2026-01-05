class AiWeeklyMenuAvailability {
  bool _disabled = false;

  bool get isDisabled => _disabled;

  void markDisabled() {
    _disabled = true;
  }

  void reset() {
    _disabled = false;
  }
}
