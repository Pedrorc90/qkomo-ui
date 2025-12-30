import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/http/dio_provider.dart';
import 'package:qkomo_ui/features/profile/data/companion_local_data_source.dart';
import 'package:qkomo_ui/features/profile/data/companion_repository.dart';
import 'package:qkomo_ui/features/profile/domain/companion.dart';

final companionRepositoryProvider = Provider<CompanionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CompanionRepository(
    dio: dio,
    localDataSource: CompanionLocalDataSource(),
  );
});

final companionListProvider =
    AsyncNotifierProvider.autoDispose<CompanionListNotifier, List<Companion>>(() {
  return CompanionListNotifier();
});

class CompanionListNotifier extends AutoDisposeAsyncNotifier<List<Companion>> {
  @override
  Future<List<Companion>> build() async {
    final repository = ref.watch(companionRepositoryProvider);

    // 1. Initial Load: Return cached data immediately
    final cached = repository.getCachedCompanions();

    // 2. Background Sync: Trigger remote fetch
    // Use Future.microtask to avoid build side-effects or just fire-and-forget
    _syncRemote(repository);

    return cached;
  }

  Future<void> _syncRemote(CompanionRepository repository) async {
    // Wait for the build phase to complete to safely update state
    await Future.delayed(Duration.zero);

    try {
      final remoteData = await repository.syncRemoteCompanions();
      state = AsyncValue.data(remoteData);
    } catch (e) {
      // If we have data, we stay in 'data' state (silent error).
      // If we don't have data (e.g. first launch offline), we might want to show error?
      // User requested "Offline First. Don't show loading. If info was never loaded, shouldn't show a connection error"
      // So if clean state, maybe just return empty list?

      if (state.valueOrNull == null || state.valueOrNull!.isEmpty) {
        // If we really want to avoid "Connection Error" screen even on first launch:
        // We could just log it and stay empty?
        // Or if the error is network, we treat it as "just show what we have (nothing)".
        // state = AsyncValue.error(e, stack); // This shows error screen
        // state = AsyncValue.data([]); // This shows empty state ("Add companion")

        // Let's decide: If we have NO cached data and sync fails, showing "Add Companion" is better than "Error"?
        // Or strictly speaking, if offline, we show empty state.
        // Let's keep existing data if present.
      }
      // Silent fail - keeping existing state (cached)
    }
  }
}

class CompanionController extends StateNotifier<AsyncValue<void>> {
  CompanionController(this._repository) : super(const AsyncValue.data(null));

  final CompanionRepository _repository;

  Future<void> inviteCompanion(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.inviteCompanion(email));
  }

  Future<void> removeCompanion(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.removeCompanion(id));
  }
}

final companionControllerProvider =
    StateNotifierProvider<CompanionController, AsyncValue<void>>((ref) {
  return CompanionController(ref.watch(companionRepositoryProvider));
});
