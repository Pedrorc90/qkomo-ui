import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de reintentos de red
class RetryState {
  const RetryState({
    this.isRetrying = false,
    this.retryCount = 0,
  });
  final bool isRetrying;
  final int retryCount;

  RetryState copyWith({
    bool? isRetrying,
    int? retryCount,
  }) {
    return RetryState(
      isRetrying: isRetrying ?? this.isRetrying,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

/// StateNotifier to manage retry state with automatic timeout
class RetryStateNotifier extends StateNotifier<RetryState> {
  RetryStateNotifier() : super(const RetryState());

  Timer? _timeoutTimer;

  void startRetry(int retryCount) {
    // Cancel previous timeout if it exists
    _timeoutTimer?.cancel();

    state = state.copyWith(
      isRetrying: true,
      retryCount: retryCount,
    );

    // Automatic timeout of 10 seconds: if no success in that time, clear
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      endRetry();
    });
  }

  void endRetry() {
    // Cancel timeout
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    state = const RetryState();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }
}

/// Provider para el estado de reintentos
final retryStateProvider =
    StateNotifierProvider<RetryStateNotifier, RetryState>((ref) {
  return RetryStateNotifier();
});
