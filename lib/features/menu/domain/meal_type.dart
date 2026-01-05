enum MealType {
  lunch, // Comida
  dinner, // Cena
}

extension MealTypeExtension on MealType {
  String get displayName {
    switch (this) {
      case MealType.lunch:
        return 'Comida';
      case MealType.dinner:
        return 'Cena';
    }
  }
}
