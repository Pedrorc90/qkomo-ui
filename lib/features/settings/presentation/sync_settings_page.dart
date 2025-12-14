import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/core/config/feature_flags.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';

class SyncSettingsPage extends ConsumerWidget {
  const SyncSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!FeatureFlags.enableCloudSync) {
      return Scaffold(
        appBar: const QkomoNavBar(),
        body: const Center(
          child: Text('Cloud sync is currently disabled.'),
        ),
      );
    }

    return Scaffold(
      appBar: const QkomoNavBar(),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Cloud Sync'),
            subtitle: const Text('Backup your data to the cloud'),
            value: true, // TODO: Connect to actual preference
            onChanged: (value) {
              // TODO: Implement preference toggle
            },
          ),
          ListTile(
            title: const Text('Sync Now'),
            subtitle: const Text('Manually trigger synchronization'),
            trailing: const Icon(Icons.sync),
            onTap: () async {
              final syncService = ref.read(syncServiceProvider);
              await syncService.sync();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sync triggered')),
                );
              }
            },
          ),
          const Divider(),
          Consumer(
            builder: (context, ref, child) {
              final pendingCount = ref.watch(pendingSyncCountProvider);
              return ListTile(
                title: const Text('Sync Status'),
                subtitle: pendingCount.when(
                  data: (count) => Text(
                      count > 0 ? '$count items pending sync' : 'All synced'),
                  loading: () => const Text('Checking status...'),
                  error: (e, _) => const Text('Error checking status'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
