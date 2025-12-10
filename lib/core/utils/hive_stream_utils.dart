import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Creates a Stream from a Hive Box that emits a new value whenever the box changes.
///
/// [ref] is the Ref from the provider, used to handle disposal.
/// [box] is the Hive Box to listen to.
/// [transformer] is a function that maps the Box to the desired output type [T].
///
/// This helper manages the [StreamController] and subscription lifecycle automatically.
Stream<T> createHiveStream<T, B>({
  required Ref ref,
  required Box<B> box,
  required T Function(Box<B>) transformer,
}) {
  // Create a controller that will emit the transformed values
  final controller = StreamController<T>();

  // Helper to emit the current state
  void emit() {
    if (!controller.isClosed) {
      controller.add(transformer(box));
    }
  }

  // Emit initial value
  emit();

  // Listen for changes in the box
  final subscription = box.watch().listen((_) {
    emit();
  });

  // Clean up when the provider is disposed
  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
}
