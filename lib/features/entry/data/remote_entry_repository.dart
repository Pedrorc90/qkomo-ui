import 'package:qkomo_ui/features/entry/domain/entry.dart';

class RemoteEntryRepository {
  // TODO: Inject Dio client when backend is ready

  Future<List<Entry>> fetchEntries({DateTime? from, DateTime? to}) async {
    // Placeholder: Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  Future<void> pushEntry(Entry entry) async {
    // Placeholder: Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate success
  }

  Future<void> deleteEntry(String id) async {
    // Placeholder: Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
