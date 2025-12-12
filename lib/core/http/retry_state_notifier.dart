import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de reintentos de red
class RetryState {
  final bool isRetrying;
  final int retryCount;

  const RetryState({
    this.isRetrying = false,
    this.retryCount = 0,
  });

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

/// StateNotifier para manejar el estado de reintentos
class RetryStateNotifier extends StateNotifier<RetryState> {
  RetryStateNotifier() : super(const RetryState());

  void startRetry(int retryCount) {
    state = state.copyWith(
      isRetrying: true,
      retryCount: retryCount,
    );
  }

  void endRetry() {
    state = const RetryState();
  }
}

/// Provider para el estado de reintentos
final retryStateProvider =
    StateNotifierProvider<RetryStateNotifier, RetryState>((ref) {
  return RetryStateNotifier();
});
