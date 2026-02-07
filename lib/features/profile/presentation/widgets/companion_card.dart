import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/profile/domain/entities/companion.dart';

/// Card displaying companion information with remove option
class CompanionCard extends StatelessWidget {
  const CompanionCard({
    required this.companion,
    required this.onRemove,
    super.key,
  });

  final Companion companion;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: companion.photoUrl != null
              ? NetworkImage(companion.photoUrl!)
              : null,
          child: companion.photoUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text(
          companion.displayName ?? companion.email,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          companion.isPending ? 'Invitación enviada' : 'Compañero',
          style: TextStyle(
            color: companion.isPending
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
