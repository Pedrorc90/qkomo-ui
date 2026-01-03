import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSummaryCard extends StatelessWidget {
  const UserSummaryCard({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final email = user?.email ?? 'Desconocido';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withAlpha((0.15 * 255).round()),
              child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? email,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(email,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
            ),
            const Icon(Icons.verified_user_outlined),
          ],
        ),
      ),
    );
  }
}
