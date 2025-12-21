import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/domain/meal_image_constants.dart';

class PresetRecipe {
  final String name;
  final List<String> ingredients;
  final String photoPath;
  final MealType suggestedMealType;

  const PresetRecipe({
    required this.name,
    required this.ingredients,
    required this.photoPath,
    required this.suggestedMealType,
  });
}

class PresetRecipes {
  static final List<PresetRecipe> all = [
    // Desayunos
    PresetRecipe(
      name: 'Tostadas con Tomate',
      ingredients: [
        'Pan',
        'Tomate',
        'Aceite de oliva',
        'Sal',
        'Jamón serrano',
      ],
      photoPath: MealImages.tostadas,
      suggestedMealType: MealType.breakfast,
    ),
    PresetRecipe(
      name: 'Café con Leche y Galletas',
      ingredients: [
        'Café',
        'Leche',
        'Galletas María',
        'Azúcar',
      ],
      photoPath: MealImages.cafeGalletas,
      suggestedMealType: MealType.breakfast,
    ),
    PresetRecipe(
      name: 'Churros con Chocolate',
      ingredients: [
        'Churros',
        'Chocolate caliente',
        'Azúcar',
      ],
      photoPath: MealImages.churros,
      suggestedMealType: MealType.breakfast,
    ),
    // Comidas
    PresetRecipe(
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
    PresetRecipe(
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
    PresetRecipe(
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
    PresetRecipe(
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
    PresetRecipe(
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
    // Meriendas
    PresetRecipe(
      name: 'Bocadillo de Jamón',
      ingredients: [
        'Pan',
        'Jamón serrano',
        'Tomate',
        'Aceite de oliva',
      ],
      photoPath: MealImages.bocadilloJamon,
      suggestedMealType: MealType.snack,
    ),
    PresetRecipe(
      name: 'Frutas y Yogur',
      ingredients: [
        'Yogur natural',
        'Fresas',
        'Plátano',
        'Miel',
      ],
      photoPath: MealImages.frutasYogur,
      suggestedMealType: MealType.snack,
    ),
    PresetRecipe(
      name: 'Magdalenas Caseras',
      ingredients: [
        'Harina',
        'Huevos',
        'Azúcar',
        'Aceite',
        'Levadura',
        'Leche',
      ],
      photoPath: MealImages.magdalenas,
      suggestedMealType: MealType.snack,
    ),
    // Cenas
    PresetRecipe(
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
    PresetRecipe(
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
    PresetRecipe(
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
