import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/history/utils/date_grouping_helper.dart';

/// Header for date group sections
class DateGroupHeader extends StatelessWidget {
  const DateGroupHeader({
    super.key,
    required this.group,
    this.date,
  });

  final DateGroup group;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final label = DateGroupingHelper.getDateGroupLabel(group, date: date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        "hola",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
