import 'package:flutter/material.dart';

class DayHeaderWithActions extends StatelessWidget {
  const DayHeaderWithActions({
    super.key,
    required this.dateText,
    required this.onAutoGenerate,
    required this.onClearMeals,
    this.onGenerateSuggestions,
    this.showSuggestionsButton = false,
  });

  final String dateText;
  final VoidCallback onAutoGenerate;
  final VoidCallback onClearMeals;
  final VoidCallback? onGenerateSuggestions;
  final bool showSuggestionsButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.restaurant_menu,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: onAutoGenerate,
            tooltip: 'Generar menú automático',
            visualDensity: VisualDensity.compact,
          ),
          if (showSuggestionsButton)
            IconButton(
              icon: Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: onGenerateSuggestions,
              tooltip: 'Sugerencias IA',
              visualDensity: VisualDensity.compact,
            ),
          IconButton(
            icon: Icon(
              Icons.delete_sweep,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: onClearMeals,
            tooltip: 'Limpiar comidas',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
