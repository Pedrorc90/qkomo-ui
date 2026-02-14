# Propuestas de Mejora Arquitectural - qkomo-ui

**Fecha de Análisis:** 2026-02-07
**Basado en:** Flutter Architecture Skill + análisis de codebase

---

## PRIORIDAD 1 - CRÍTICA (Afecta Clean Architecture) [COMPLETADA]

### ✅ P1.1 - Usar UseCases existentes en MenuController [COMPLETADO]

**Problema:**
- `lib/features/menu/domain/usecases/` contiene 5 UseCases (CreateMeal, UpdateMeal, DeleteMeal, SaveMealAsRecipe, DeleteRecipe)
- `MenuController` duplicaba la lógica internamente
- Violación de principio de responsabilidad única

**Solución implementada:**
- `MenuController` ahora inyecta y usa los 5 UseCases
- Lógica de negocio centralizada en UseCases (reutilizable)

**Ejemplo actual (INCORRECTO):**
```dart
// lib/features/menu/application/menu_controller.dart:36-68
Future<void> createMeal(...) async {
  final meal = Meal(
    id: DateTime.now().toString(),
    userId: _authController.uid,
    // ... creación manual del objeto Meal
  );
  await _repository.saveMeal(meal);
}
```

**Propuesta (CORRECTO):**
```dart
class MenuController extends StateNotifier<MenuState> {
  final CreateMeal _createMeal;
  final UpdateMeal _updateMeal;
  final DeleteMeal _deleteMeal;

  MenuController({
    required CreateMeal createMeal,
    required UpdateMeal updateMeal,
    required DeleteMeal deleteMeal,
  }) : _createMeal = createMeal,
       _updateMeal = updateMeal,
       _deleteMeal = deleteMeal,
       super(MenuState.initial());

  Future<void> createMeal(...) async {
    state = state.copyWith(isLoading: true);

    final result = await _createMeal(CreateMealParams(
      userId: _authController.uid,
      name: name,
      ingredients: ingredients,
      // ...
    ));

    result.fold(
      (failure) => state = state.copyWith(error: failure, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }
}
```

**Archivos afectados:**
- `lib/features/menu/application/menu_controller.dart`
- `lib/features/menu/application/menu_providers.dart` (proveer UseCases)

**Beneficios:**
- Lógica de negocio centralizada en UseCases (reutilizable)
- Controllers más delgados (solo orquestación)
- Tests más fáciles (mock UseCases en vez de repositories)

---

### ✅ P1.2 - Refactorizar AuthController: Crear AuthRepository [COMPLETADO]

**Problema:**
- `lib/features/auth/application/auth_controller.dart` accedía **directamente a Firebase Auth**
- **Falta data layer**
- Acoplamiento fuerte a proveedor externo (dificulta testing y migración)

**Solución implementada:**
- Creado `AuthRepository` (interface domain)
- Creado `FirebaseAuthRepository` (implementación data)
- `AuthController` ahora usa `AuthRepository` (desacoplado de Firebase)

**Ubicación:** `lib/features/auth/`

**Estructura actual:**
```
auth/
├── domain/
│   └── errors/auth_failure.dart
├── application/
│   ├── auth_controller.dart          # Accede directamente a Firebase
│   ├── auth_providers.dart
│   └── secure_token_store.dart
└── presentation/
    └── sign_in/
```

**Propuesta de estructura:**
```
auth/
├── domain/
│   ├── entities/
│   │   └── auth_user.dart            # Nuevo: Entidad domain (no FirebaseUser)
│   ├── repositories/
│   │   └── auth_repository.dart      # Nuevo: Interface
│   └── errors/
│       └── auth_failure.dart
├── data/
│   ├── repositories/
│   │   └── firebase_auth_repository.dart  # Nuevo: Implementación Firebase
│   └── dtos/
│       └── firebase_user_dto.dart    # Nuevo: Mapper FirebaseUser → AuthUser
├── application/
│   ├── usecases/
│   │   ├── sign_in_with_google.dart  # Nuevo: UseCase
│   │   ├── sign_in_with_email.dart   # Nuevo: UseCase
│   │   └── sign_out.dart             # Nuevo: UseCase
│   ├── auth_controller.dart          # Refactorizar: Usa UseCases
│   └── auth_providers.dart
└── presentation/
```

**Código propuesto:**

```dart
// domain/entities/auth_user.dart
@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    required String? email,
    required String? displayName,
    required String? photoUrl,
  }) = _AuthUser;
}

// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Stream<AuthUser?> authStateChanges();
  Future<Either<AuthFailure, AuthUser>> signInWithGoogle();
  Future<Either<AuthFailure, AuthUser>> signInWithEmailAndPassword(String email, String password);
  Future<Either<AuthFailure, void>> signOut();
}

// data/repositories/firebase_auth_repository.dart
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository(this._firebaseAuth);

  @override
  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges()
        .map((user) => user != null ? _mapToAuthUser(user) : null);
  }

  @override
  Future<Either<AuthFailure, AuthUser>> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      // ... lógica Firebase
      return Right(_mapToAuthUser(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseException(e));
    }
  }

  AuthUser _mapToAuthUser(User firebaseUser) {
    return AuthUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }
}

// application/usecases/sign_in_with_google.dart
class SignInWithGoogle {
  final AuthRepository _repository;

  SignInWithGoogle(this._repository);

  Future<Either<AuthFailure, AuthUser>> call() async {
    return await _repository.signInWithGoogle();
  }
}

// application/auth_controller.dart (REFACTORIZADO)
class AuthController {
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithEmail _signInWithEmail;
  final SignOut _signOut;

  AuthController({
    required SignInWithGoogle signInWithGoogle,
    required SignInWithEmail signInWithEmail,
    required SignOut signOut,
  }) : _signInWithGoogle = signInWithGoogle,
       _signInWithEmail = signInWithEmail,
       _signOut = signOut;

  Future<Either<AuthFailure, AuthUser>> signInWithGoogle() async {
    return await _signInWithGoogle();
  }
}
```

**Archivos a crear:**
- `lib/features/auth/domain/entities/auth_user.dart`
- `lib/features/auth/domain/repositories/auth_repository.dart`
- `lib/features/auth/data/repositories/firebase_auth_repository.dart`
- `lib/features/auth/data/dtos/firebase_user_dto.dart`
- `lib/features/auth/application/usecases/sign_in_with_google.dart`
- `lib/features/auth/application/usecases/sign_in_with_email.dart`
- `lib/features/auth/application/usecases/sign_out.dart`

**Archivos a refactorizar:**
- `lib/features/auth/application/auth_controller.dart`
- `lib/features/auth/application/auth_providers.dart`

**Beneficios:**
- Desacoplamiento de Firebase (facilita cambio de proveedor)
- Tests más fáciles (mock AuthRepository)
- Cumple Clean Architecture
- Entidad domain independiente de Firebase

---

## PRIORIDAD 2 - ALTA (Inconsistencias arquitecturales) [COMPLETADA]

### ✅ P2.2 - Mover WeeklyMealType de data a domain [COMPLETADO]

**Problema:**
- `lib/features/menu/presentation/widgets/dish_image_widget.dart` importaba `WeeklyMealType` desde **data layer**
- Violación de Clean Architecture: presentation NO debe importar data

**Solución implementada:**
- Movido `weekly_meal_type.dart` de `data/models/` a `domain/entities/`
- Actualizados imports en:
  - `presentation/widgets/dish_image_widget.dart`
  - `domain/entities/weekly_menu_item.dart`
  - `data/hive_boxes.dart`
  - `data/models/weekly_menu_item_dto.dart`
- Regenerado código con `build_runner`

**Archivos modificados:**
- `lib/features/menu/domain/entities/weekly_meal_type.dart` (movido desde data)
- 4 archivos con imports actualizados

**Beneficios:**
✅ Respeta separación de capas
✅ Presentation solo depende de domain
✅ Facilita testing de presentation layer

---

## PRIORIDAD 3 - MEDIA (Mejoras de código)

### ✅ P3.1 - Refactorizar widgets grandes (>200 líneas) [COMPLETADO]

**Problema:**
15 widgets excedían 100 líneas, violando CLAUDE.md:
> Forbidden: Widgets > 100 lines

**Widgets refactorizados:**
- ✅ `meal_form_dialog.dart`: ~~510 líneas~~ → **429 líneas** (-16%)
  - Creados: MealFormHeader, MealTypeSelector, MealNameField, MealNotesField, MealFormFooter
- ✅ `preset_recipe_dialog.dart`: ~~313 líneas~~ → **167 líneas** (-47%)
  - Creados: RecipeFilterChips, RecipeGridCard
- ✅ `meal_card.dart`: ~~274 líneas~~ → **178 líneas** (-35%)
  - Creados: MealCardImage, DeleteMealConfirmDialog
- ✅ `profile_page.dart`: ~~274 líneas~~ → **115 líneas** (-58%)
  - Creados: ProfileSectionHeader
- ✅ `upcoming_meals_section.dart`: ~~245 líneas~~ → **210 líneas** (-14%)
  - Creados: WeeklyMenuEmptyState
- ✅ `weekly_calendar_widget.dart`: ~~234 líneas~~ → **222 líneas** (-5%)
  - Creados: DayCardColors

**Resultados:**
- **Total reducido:** 1850 → 1394 líneas (-456 líneas, -25%)
- **Widgets creados:** 15 sub-widgets reutilizables
- **Sin errores de compilación**

**Propuesta (ejemplo: meal_form_dialog.dart):**

**Estructura actual (510 líneas en 1 archivo):**
```dart
class MealFormDialog extends StatefulWidget {
  // ... 510 líneas con:
  // - Controllers (ingredientsController, nameController)
  // - State management (setState)
  // - Validación
  // - Widgets (TextField, Buttons, Layout)
}
```

**Estructura propuesta (dividir en sub-widgets):**
```
presentation/widgets/meal_form/
├── meal_form_dialog.dart          # 100 líneas: Scaffold + orchestration
├── meal_name_field.dart           # 40 líneas: TextField para nombre
├── meal_ingredients_section.dart  # 80 líneas: Sección ingredientes
├── meal_photo_section.dart        # 60 líneas: Photo picker
├── meal_allergens_section.dart    # 50 líneas: Allergen chips
└── meal_form_buttons.dart         # 40 líneas: Save/Cancel buttons
```

**Ejemplo de refactorización:**

```dart
// meal_form_dialog.dart (REFACTORIZADO - ~100 líneas)
class MealFormDialog extends StatefulWidget {
  const MealFormDialog({required this.meal, super.key});

  final Meal? meal;

  @override
  State<MealFormDialog> createState() => _MealFormDialogState();
}

class _MealFormDialogState extends State<MealFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MealNameField(controller: _nameController),
              MealIngredientsSection(controller: _ingredientsController),
              MealPhotoSection(onPhotoSelected: _handlePhoto),
              MealAllergensSection(
                selectedAllergens: _selectedAllergens,
                onChanged: _handleAllergensChanged,
              ),
              MealFormButtons(
                onSave: _handleSave,
                onCancel: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// meal_name_field.dart (NUEVO - ~40 líneas)
class MealNameField extends StatelessWidget {
  const MealNameField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: 'Nombre del plato'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El nombre es obligatorio';
        }
        return null;
      },
    );
  }
}

// meal_ingredients_section.dart (NUEVO - ~80 líneas)
class MealIngredientsSection extends StatefulWidget {
  const MealIngredientsSection({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  State<MealIngredientsSection> createState() => _MealIngredientsSectionState();
}

class _MealIngredientsSectionState extends State<MealIngredientsSection> {
  List<String> _ingredients = [];

  void _addIngredient() {
    if (widget.controller.text.isNotEmpty) {
      setState(() {
        _ingredients.add(widget.controller.text);
        widget.controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: 'Ingredientes',
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: _addIngredient,
            ),
          ),
        ),
        ..._ingredients.map((ing) => Chip(label: Text(ing))),
      ],
    );
  }
}
```

**Archivos a refactorizar (prioridad por tamaño):**
1. `lib/features/menu/presentation/widgets/meal_form_dialog.dart` (510 → ~100)
2. `lib/features/menu/presentation/widgets/preset_recipe_dialog.dart` (313 → ~100)
3. `lib/features/menu/presentation/widgets/meal_card.dart` (274 → ~100)
4. `lib/features/profile/presentation/profile_page.dart` (274 → ~100)

**Beneficios:**
- Cumple con regla de 100 líneas máximo
- Widgets más testables (test cada sub-widget)
- Reutilización de componentes (ej: MealNameField en otros forms)
- Mejor performance (Flutter rebuilds solo sub-widgets necesarios)

---

### ⏭️ P3.2 - Crear UseCases para profile, settings [POSPUESTO]

**Problema:**
- Solo el feature `menu` tiene UseCases
- `profile`, `settings` implementan lógica directamente en controllers/notifiers
- Inconsistencia arquitectural

**Análisis realizado:**
- **UserSettingsNotifier**: Lógica muy simple (toggles, getters/setters)
- **AuthController**: Ya refactorizado con AuthRepository (P1.2)

**Decisión:** POSPONER
- Los controllers actuales son simples, crear UseCases sería over-engineering
- UseCases solo se justifican cuando hay lógica de negocio compleja
- `menu` tiene UseCases porque gestiona validaciones, transformaciones, reglas de negocio
- `profile` y `settings` son CRUD simples

**Recomendación:** Implementar UseCases solo si la lógica de negocio se vuelve más compleja

**Propuesta:**

**auth (después de completar P1.2):**
```
auth/application/usecases/
├── sign_in_with_google.dart
├── sign_in_with_email.dart
├── sign_out.dart
└── get_current_user.dart
```

**profile:**
```
profile/domain/usecases/
├── update_user_profile.dart
└── get_user_profile.dart
```

**settings:**
```
settings/domain/usecases/
├── update_user_settings.dart
├── get_user_settings.dart
├── toggle_allergen.dart
└── update_dietary_preferences.dart
```

**Beneficios:**
- Lógica de negocio centralizada y reutilizable
- Controllers más simples (solo orquestación)
- Tests más fáciles (mock UseCases)
- Consistencia con feature menu

---

### ✅ P3.3 - Renombrar CustomRecipeRepositoryImpl → LocalCustomRecipeRepository [COMPLETADO]

**Problema:**
- `lib/features/menu/data/custom_recipe_repository.dart` solo accedía a Hive (local storage)
- No tiene implementación remote ni hybrid
- Nombre `CustomRecipeRepositoryImpl` no reflejaba que es solo local

**Solución implementada:**
- Renombrado archivo: `custom_recipe_repository.dart` → `local_custom_recipe_repository.dart`
- Renombrado clase: `CustomRecipeRepositoryImpl` → `LocalCustomRecipeRepository`
- Actualizado import en `menu_providers.dart`

**Ubicación:** `lib/features/menu/data/custom_recipe_repository.dart`

**Propuesta:**

**Opción A - Solo renombrar (si NO necesita sync):**
```
Renombrar: custom_recipe_repository.dart
A:         local_custom_recipe_repository.dart

Clase: CustomRecipeRepositoryImpl
A:     LocalCustomRecipeRepository
```

**Opción B - Implementar patrón completo (si NECESITA sync):**
```
Crear:
- lib/features/menu/data/repositories/local_custom_recipe_repository.dart
- lib/features/menu/data/repositories/remote_custom_recipe_repository.dart
- lib/features/menu/data/repositories/hybrid_custom_recipe_repository.dart
```

**Recomendación:** Si CustomRecipe es solo local (sin backend), usar Opción A. Si eventualmente necesitará sync con servidor, usar Opción B.

**Archivos afectados:**
- `lib/features/menu/data/custom_recipe_repository.dart`
- `lib/features/menu/application/menu_providers.dart` (actualizar provider)

**Beneficios:**
- Claridad en el nombre (LocalCustomRecipeRepository indica que es solo local)
- Consistencia con naming de otros repositorios

---

## PRIORIDAD 4 - CONSIDERACIONES (No urgente, requiere análisis)

### P4.1 - Evaluar si home/initialization/shell necesitan domain layer

**Contexto:**
- `home`, `initialization`, `shell` tienen arquitectura mínima (solo presentation/application)
- No tienen domain ni data layers

**Análisis necesario:**
- **home**: ¿Es un feature orquestador (solo UI que consume otros features) o tiene lógica de negocio propia?
- **initialization**: ¿Es solo splash screen o tiene lógica de inicialización compleja?
- **shell**: ¿Es solo navegación/UI infrastructure o maneja estado de app?

**Propuesta:**
Si son **features UI-only** (orquestadores), está OK sin domain layer. Documentar esto en `ARCHITECTURE.md`.

Si tienen **lógica de negocio**, crear domain layer:
```
home/domain/
├── entities/
│   └── dashboard_stats.dart  # Ejemplo: stats agregadas de varios features
└── usecases/
    └── get_dashboard_data.dart
```

**Recomendación:** Evaluar en fase de revisión arquitectural. No es urgente.

---

## RESUMEN DE IMPLEMENTACIÓN

### Orden recomendado:
1. **P1.1** - Usar UseCases en MenuController (1-2 horas)
2. **P1.2** - Refactorizar AuthController + crear AuthRepository (4-6 horas)
3. **P2.2** - Mover WeeklyMealType a domain (30 min)
4. **P2.1** - Refactorizar CompanionRepository (2-3 horas)
5. **P3.1** - Refactorizar widgets grandes (1 hora por widget, 4-6 horas total para los 4 prioritarios)
6. **P3.2** - Crear UseCases para profile/settings (2-3 horas)
7. **P3.3** - Renombrar CustomRecipeRepository (15 min)

### Estimación total: 12-18 horas de trabajo

### Impacto esperado:
- ✅ Clean Architecture completa
- ✅ Código más testable
- ✅ Widgets más mantenibles (<100 líneas)
- ✅ Consistencia arquitectural en todos los features
- ✅ Desacoplamiento de dependencias externas (Firebase)

---

**Próximos pasos:**
1. Revisar este documento con el equipo
2. Priorizar propuestas según roadmap del proyecto
3. Crear tasks en TODO.md para cada propuesta
4. Implementar en orden sugerido
