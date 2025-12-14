import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final name = user?.displayName?.split(' ').first ?? '';
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM', 'es').format(now);
    // Capitalize first letter of the date
    final formattedDate =
        dateStr.substring(0, 1).toUpperCase() + dateStr.substring(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hola, $name',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onBackground,
                        height: 1.1,
                      ),
                ),
              ),
              // Optional: Add a small profile avatar here if available
              if (user?.photoURL != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoURL!),
                  radius: 24,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
