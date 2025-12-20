import 'dart:async';
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

/// StateNotifier para manejar el estado de reintentos con timeout automático
class RetryStateNotifier extends StateNotifier<RetryState> {
  RetryStateNotifier() : super(const RetryState());

  Timer? _timeoutTimer;

  void startRetry(int retryCount) {
    // Cancelar timeout anterior si existe
    _timeoutTimer?.cancel();

    state = state.copyWith(
      isRetrying: true,
      retryCount: retryCount,
    );

    // Timeout automático de 10 segundos: si no hay éxito en ese tiempo, limpiar
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      endRetry();
    });
  }

  void endRetry() {
    // Cancelar timeout
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
