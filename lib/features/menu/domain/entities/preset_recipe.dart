import 'package:qkomo_ui/features/menu/domain/meal_image_constants.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class PresetRecipe {
  const PresetRecipe({
    required this.name,
    required this.ingredients,
    required this.photoPath,
    required this.suggestedMealType,
  });
  final String name;
  final List<String> ingredients;
  final String photoPath;
  final MealType suggestedMealType;
}

class PresetRecipes {
  static final List<PresetRecipe> all = [
    // Comidas
    const PresetRecipe(
      name: 'Paella Valenciana',
      ingredients: [
        'Arroz',
        'Pollo',
        'Conejo',
        'Judías verdes',
        'Garrofón',
        'Azafrán',
        'Aceite de oliva',
        'Sal',
      ],
      photoPath: MealImages.paella,
      suggestedMealType: MealType.lunch,
    ),
    const PresetRecipe(
      name: 'Gazpacho',
      ingredients: [
        'Tomates',
        'Pepino',
        'Pimiento verde',
        'Ajo',
        'Pan',
        'Aceite de oliva',
        'Vinagre',
        'Sal',
      ],
      photoPath: MealImages.gazpacho,
      suggestedMealType: MealType.lunch,
    ),
    const PresetRecipe(
      name: 'Ensalada Mixta',
      ingredients: [
        'Lechuga',
        'Tomate',
        'Cebolla',
        'Atún',
        'Huevo duro',
        'Aceitunas',
        'Espárragos',
        'Aceite de oliva',
      ],
      photoPath: MealImages.ensalada,
      suggestedMealType: MealType.lunch,
    ),
    const PresetRecipe(
      name: 'Pollo al Horno',
      ingredients: [
        'Pollo',
        'Patatas',
        'Cebolla',
        'Zanahoria',
        'Ajo',
        'Romero',
        'Aceite de oliva',
        'Sal y pimienta',
      ],
      photoPath: MealImages.pollo,
      suggestedMealType: MealType.lunch,
    ),
    const PresetRecipe(
      name: 'Lentejas Estofadas',
      ingredients: [
        'Lentejas',
        'Chorizo',
        'Zanahoria',
        'Patata',
        'Cebolla',
        'Ajo',
        'Pimentón',
        'Laurel',
      ],
      photoPath: MealImages.lentejas,
      suggestedMealType: MealType.lunch,
    ),
    // Cenas
    const PresetRecipe(
      name: 'Tortilla Española',
      ingredients: [
        'Huevos',
        'Patatas',
        'Cebolla',
        'Aceite de oliva',
        'Sal',
      ],
      photoPath: MealImages.tortilla,
      suggestedMealType: MealType.dinner,
    ),
    const PresetRecipe(
      name: 'Sopa de Verduras',
      ingredients: [
        'Zanahoria',
        'Calabacín',
        'Puerro',
        'Patata',
        'Cebolla',
        'Aceite de oliva',
        'Sal',
      ],
      photoPath: MealImages.sopaVerduras,
      suggestedMealType: MealType.dinner,
    ),
    const PresetRecipe(
      name: 'Pescado a la Plancha',
      ingredients: [
        'Pescado blanco',
        'Limón',
        'Ajo',
        'Perejil',
        'Aceite de oliva',
        'Sal',
      ],
      photoPath: MealImages.pescadoPlancha,
      suggestedMealType: MealType.dinner,
    ),
  ];
}
