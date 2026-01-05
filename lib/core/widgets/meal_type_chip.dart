import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Enum for different MealTypeChip display variants
enum MealTypeChipVariant {
  /// Standard FilterChip with icon and full Spanish label
  standard,

  /// Compact variant with reduced padding and height
  compact,

  /// Icon-only variant without text label
  iconOnly,
}

/// A color-coded meal type chip widget for selecting lunch or dinner.
///
/// Displays meal types with semantically meaningful colors:
/// - Lunch (Comida): Teal (#4DB6AC)
/// - Dinner (Cena): Purple (#9575CD)
///
/// Supports three display variants:
/// - **standard**: FilterChip with icon and Spanish label (default)
/// - **compact**: Reduced height and padding for dense layouts
/// - **iconOnly**: Just the meal type icon in a CircleAvatar
///
/// Example:
/// ```dart
/// MealTypeChip(
///   mealType: MealType.lunch,
///   isSelected: true,
///   onTap: () => print('Lunch selected'),
/// )
///
/// // Compact variant for meal selection in lists
/// MealTypeChip(
///   mealType: MealType.lunch,
///   variant: MealTypeChipVariant.compact,
/// )
///
/// // Icon-only for minimal space
/// MealTypeChip(
///   mealType: MealType.dinner,
///   variant: MealTypeChipVariant.iconOnly,
/// )
/// ```
class MealTypeChip extends StatelessWidget {
  const MealTypeChip({
    super.key,
    required this.mealType,
    this.isSelected = false,
    this.onTap,
    this.variant = MealTypeChipVariant.standard,
  });

  /// The meal type to display
  final MealType mealType;

  /// Whether this chip is currently selected
  final bool isSelected;

  /// Callback when the chip is tapped
  final VoidCallback? onTap;

  /// The display variant for this chip
  final MealTypeChipVariant variant;

  /// Get the accent color for a meal type
  Color _getMealTypeColor() {
    switch (mealType) {
      case MealType.lunch:
        return const Color(0xFF4DB6AC); // Teal
      case MealType.dinner:
        return const Color(0xFF9575CD); // Purple
    }
  }

  /// Get the icon for a meal type
  IconData _getMealTypeIcon() {
    switch (mealType) {
      case MealType.lunch:
        return Icons.restaurant;
      case MealType.dinner:
        return Icons.dinner_dining;
    }
  }

  /// Get the semantic label in Spanish
  String _getSemanticLabel() {
    final selected = isSelected ? 'seleccionado' : 'no seleccionado';
    return '${mealType.displayName}, $selected';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getMealTypeColor();
    final icon = _getMealTypeIcon();

    return Semantics(
      label: _getSemanticLabel(),
      enabled: onTap != null,
      onTap: onTap,
      child: switch (variant) {
        MealTypeChipVariant.standard => _buildStandardChip(icon, color),
        MealTypeChipVariant.compact => _buildCompactChip(icon, color),
        MealTypeChipVariant.iconOnly => _buildIconOnlyChip(icon, color),
      },
    );
  }

  /// Builds the standard FilterChip variant with icon and text
  Widget _buildStandardChip(IconData icon, Color color) {
    return FilterChip(
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      avatar: Icon(icon, size: 16, semanticLabel: ''),
      label: Text(mealType.displayName),
      backgroundColor: color.withValues(alpha: 0.1),
      selectedColor: color.withValues(alpha: 0.3),
      checkmarkColor: color,
      side: BorderSide(
        color: isSelected ? color : Colors.transparent,
        width: isSelected ? DesignTokens.borderWidthMedium : 0,
      ),
    );
  }

  /// Builds the compact FilterChip variant with reduced padding
  Widget _buildCompactChip(IconData icon, Color color) {
    return FilterChip(
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      avatar: Icon(icon, size: 14, semanticLabel: ''),
      label: Text(mealType.displayName),
      backgroundColor: color.withValues(alpha: 0.1),
      selectedColor: color.withValues(alpha: 0.3),
      checkmarkColor: color,
      side: BorderSide(
        color: isSelected ? color : Colors.transparent,
        width: isSelected ? DesignTokens.borderWidthMedium : 0,
      ),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
    );
  }

  /// Builds the icon-only variant with circular background
  Widget _buildIconOnlyChip(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: isSelected ? 0.3 : 0.1),
          child: Icon(
            icon,
            color: isSelected ? color : color.withValues(alpha: 0.7),
            size: 20,
            semanticLabel: '',
          ),
        ),
      ),
    );
  }
}
