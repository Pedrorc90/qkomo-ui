enum MealType {
  breakfast, // Desayuno
  lunch, // Comida
  snack, // Merienda
  dinner, // Cena
}

extension MealTypeExtension on MealType {
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Desayuno';
      case MealType.lunch:
        return 'Comida';
      case MealType.snack:
        return 'Merienda';
      case MealType.dinner:
        return 'Cena';
    }
  }
}
