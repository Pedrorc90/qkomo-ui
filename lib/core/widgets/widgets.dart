/// Core reusable widgets for the Qkomo app.
///
/// This library exports all core widgets used across features:
/// - AllergenBadge: Standardized allergen display
/// - MealTypeChip: Color-coded meal type selector
/// - EmptyState: Reusable empty state with optional action
/// - AppButton: Unified button with loading state
/// - AnimatedCard: Card with tap scale animation
/// - QkomoLogo: Custom Qkomo brand logo
/// - QkomoNavBar: Top navigation bar with branding
/// - PlatformImage: Cross-platform image display (handles web compatibility)
///
/// Example:
/// ```dart
/// import 'package:qkomo_ui/core/widgets/widgets.dart';
///
/// // Use any core widget
/// AllergenBadge(allergen: 'Gluten')
/// MealTypeChip(mealType: MealType.breakfast)
/// EmptyState(icon: Icons.inbox_outlined, title: 'No items')
/// AppButton(label: 'Save', onPressed: save)
/// AnimatedCard(onTap: navigate, child: widget)
/// PlatformImage(path: '/path/to/image.jpg')
/// ```
library core_widgets;

export 'allergen_badge.dart';
export 'animated_card.dart';
export 'app_button.dart';
export 'empty_state.dart';
export 'meal_type_chip.dart';
export 'platform_image.dart';
export 'qkomo_logo.dart';
export 'qkomo_navbar.dart';
